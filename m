Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757282Ab1AMVSe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 16:18:34 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:48981 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755699Ab1AMVS3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 16:18:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version:content-type;
        b=mkweErOBCweCOBXhAGx46F/EDq52SL4WZCAnW8yJV8cyEOqOJ/CogKdmYtR0fL0dGB
         Z0WVkfjyTZm9I3IEfuWtkegOLAGbfMnc7uMV6IPhJVwBLSsQgMYxronYP5S+ykIESZNo
         qZbBUlB5ISpfNL2M/a9JleoIzyLfzzcLlrnPE=
From: Franck Bui-Huu <vagabon.xyz@gmail.com>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, 2nddept-manager@sdl.hitachi.co.jp,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Chase Douglas <chase.douglas@canonical.com>
Subject: Re: [PATCH -perf/perf/core  5/6] perf probe: Add variable filter support
References: <20110113124548.22426.11201.stgit@ltc236.sdl.hitachi.co.jp>
	<20110113124624.22426.72527.stgit@ltc236.sdl.hitachi.co.jp>
Date: Thu, 13 Jan 2011 22:18:24 +0100
In-Reply-To: <20110113124624.22426.72527.stgit@ltc236.sdl.hitachi.co.jp>
	(Masami Hiramatsu's message of "Thu, 13 Jan 2011 21:46:24 +0900")
Message-ID: <m3wrm87ba7.fsf@gmail.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> writes:

> Add filters support for available variable list.
> Default filter is "!__k???tab_*&!__crc_*" for
> filtering out automatically generated symbols.
>
> The format of filter rule is "[!]GLOBPATTERN", so
> you can use wild cards. If the filter rule starts with
> '!', matched variables are filter out.
>
> e.g.)
>  # perf probe -V schedule --externs --filter=cpu*

I'm wondering if the different syntax below could be simpler:

   $ perf probe add <probe>
   $ perf probe del <probe>
   $ perf probe show       

   $ perf probe list <line>
           ...       --vars[=<pattern>] [--externs] <probe>
           ...       --funcs[=<pattern>]

instead of respectively:

   $ perf probe --add=<probe>
   $ perf probe --del=<probe>
   $ perf probe [--list|-l]       

   $ perf probe [--line|-L] <line>
   $ perf probe -V <probe> [--externs] [--filter=<pattern>]
   $ perf probe --funcs

-- 
		Franck
