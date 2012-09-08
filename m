Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754863Ab2IHOeN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2012 10:34:13 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:48550 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754760Ab2IHOd7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2012 10:33:59 -0400
Message-ID: <504B574E.40907@gmail.com>
Date: Sat, 08 Sep 2012 08:33:50 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: Pekka Enberg <penberg@kernel.org>
CC: Irina Tirdea <irina.tirdea@gmail.com>, mingo@redhat.com,
        acme@ghostprotocols.net, a.p.zijlstra@chello.nl, rostedt@goodmis.org,
        paulus@samba.org, namhyung.kim@lge.com, linux-kernel@vger.kernel.org,
        Irina Tirdea <irina.tirdea@intel.com>
Subject: Re: [PATCH v2 05/12] perf tools: include basename for non-glibc systems
References: <1347065004-15306-1-git-send-email-irina.tirdea@intel.com> <1347065004-15306-6-git-send-email-irina.tirdea@intel.com> <CAOJsxLH_8h=GDaC=5MzjiFT1rfN5CHKpPX3PKDDHGubQpV1zuQ@mail.gmail.com>
In-Reply-To: <CAOJsxLH_8h=GDaC=5MzjiFT1rfN5CHKpPX3PKDDHGubQpV1zuQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/8/12 3:09 AM, Pekka Enberg wrote:
> It's safe to include <libgen.h> on glibc Linux systems as well, no? So
> there's no need to check for __BIONIC__.

Theoretically, yes. In reality compile fails in multiple places. 
basename can modify the string passed to it and several places in perf 
are passing a string marked const. Oops. I'll fix those places and 
remove the BIONIC conditional for libgen.h

David
