Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758127Ab1CCDox (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 22:44:53 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:56389 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757891Ab1CCDow convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 22:44:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=W3hSLuyP3kFsnLVP/BjPQi3C3RWsz62vK0KDf7ltNEJtNbAvAvQQO8V07lq/1T9X2+
         1aOM616rbDGl7a7b8UqdAuFjMCLqX3E3bI1EXEczTJpb7ooQjwBwOP8j5Re4o9cNO11E
         krLNugNBlCnequhTyFS7M7a/R+sT8FHLpm9gc=
MIME-Version: 1.0
In-Reply-To: <AANLkTimB4bO0d+Kumg_AYuxQUZuECfWN6MCP=_-6oWjc@mail.gmail.com>
References: <1298082321-8519-1-git-send-email-asharma@fb.com>
	<AANLkTimB4bO0d+Kumg_AYuxQUZuECfWN6MCP=_-6oWjc@mail.gmail.com>
Date: Wed, 2 Mar 2011 19:44:51 -0800
X-Google-Sender-Auth: zIU4FjNmuHNNH_eqDwzNNODv_1s
Message-ID: <AANLkTimaULacASp7vtgo_RFexUyKH1ZEUVyNy-EXZ1hE@mail.gmail.com>
Subject: Re: [perfmon2] [PATCH] Add libpfm4 support (v2).
From: Arun Sharma <arun@sharma-home.net>
To: Lin Ming <minggr@gmail.com>
Cc: Arun Sharma <asharma@fb.com>, acme@infradead.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, ming.m.lin@intel.com,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, lkml <linux-kernel@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>,
        Tom Zanussi <tzanussi@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        perfmon2-devel@lists.sourceforge.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 2, 2011 at 7:20 PM, Lin Ming <minggr@gmail.com> wrote:
>> +#ifdef LIBPFM4
>> +       printf("\n");
>> +       pfm_for_all_pmus(i) {
>> +               int ret;
>> +               pfm_pmu_info_t pinfo;
>> +               int count;
>> +               int k;
>> +
>
> Need to initialize pinfo before passing it to pfm_get_pmu_info
> +               memset(&pinfo, 0, sizeof(pinfo));
>
>> +               ret = pfm_get_pmu_info(i, &pinfo);

You can get by using my next patch which initializes pinfo.size, but
zero'ing the entire structure is a better idea (needs to be done for
attr too). I'll get this into -v3.

 -Arun
