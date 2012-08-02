Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754236Ab2HBSrk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 14:47:40 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:37394 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753167Ab2HBSri (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 14:47:38 -0400
Message-ID: <501ACB42.6060201@amacapital.net>
Date: Thu, 02 Aug 2012 11:47:30 -0700
From: Andy Lutomirski <luto@amacapital.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Jiri Olsa <jolsa@redhat.com>
CC: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com, eranian@google.com,
        gorcunov@openvz.org, tzanussi@gmail.com, mhiramat@redhat.com,
        robert.richter@amd.com, fche@redhat.com, linux-kernel@vger.kernel.org,
        masami.hiramatsu.pt@hitachi.com, drepper@gmail.com, asharma@fb.com,
        benjamin.redelings@nescent.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 03/17] perf, x86: Add copy_from_user_nmi_nochk for best
 effort copy
References: <1342959280-5361-1-git-send-email-jolsa@redhat.com> <1342959280-5361-4-git-send-email-jolsa@redhat.com>
In-Reply-To: <1342959280-5361-4-git-send-email-jolsa@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/22/2012 05:14 AM, Jiri Olsa wrote:
> Adding copy_from_user_nmi_nochk that provides the best effort
> copy regardless the requesting size crossing the task boundary.
> 
> This is going to be useful for stack dump we need in post
> DWARF CFI based unwind, where we have predefined size of
> the user stack to dump, and we need to store the most of
> the requested dump size, regardless this size is crossing
> the task boundary.

Huh?  This is a TASK_SIZE check, which makes sure that the request
doesn't cross into kernel land.  Otherwise userspace could presumably
read kernel memory by setting bogus values of sp.

--Andy
