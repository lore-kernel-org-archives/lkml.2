Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756886Ab0KNTLJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Nov 2010 14:11:09 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:55134 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756829Ab0KNTLI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Nov 2010 14:11:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=ndW0X2QXKo82CKXu004wV1gpK9dAR8p4JMmtsrkCj/cndtAt3Ks1GPUGKm43TUO5wg
         VodOA7kHEe71XmSjn2kaWTcsba01tFIoqkzJw7Yyd9ENvKIX8Ys+WeMkDY0IpvwvqkSJ
         o90f8OYczxSjhXsWmLf4HMtAel0Nw/phvMVPE=
MIME-Version: 1.0
In-Reply-To: <1289756161.2814.29.camel@zim>
References: <20101104041236.GA9389@helgaas.com>
	<1288937844.3234.1.camel@edumazet-laptop>
	<1289500084.2698.12.camel@zim>
	<201011121152.30204.knikanth@suse.de>
	<1289756161.2814.29.camel@zim>
Date: Sun, 14 Nov 2010 11:11:05 -0800
X-Google-Sender-Auth: 6ldcOA4Oy0CXAewy-SxPNIfxtE8
Message-ID: <AANLkTikUnLc8L_0+CQOwPgr-oifws=sqnFPxWz46MTCi@mail.gmail.com>
Subject: Re: divide error in select_task_rq_fair()
From: Yinghai Lu <yinghai@kernel.org>
To: Myron Stowe <myron.stowe@hp.com>
Cc: Nikanth Karthikesan <knikanth@suse.de>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Bjorn Helgaas <bjorn.helgaas@hp.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Venkatesh Pallipadi <venki@google.com>, Nikhil Rao <ncrao@google.com>,
        Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>,
        linux-kernel@vger.kernel.org, rjenties@google.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 14, 2010 at 9:36 AM, Myron Stowe <myron.stowe@hp.com> wrote:
>
> I got the same divide error with this latest patch (see attachment).  If
> I revert commit 50f2d7f682f9, the platform boots successfully.

please check patch in
http://lkml.org/lkml/2010/11/13/181

BTW, you also need to ask your BIOS guys to fix the SRAT table.
If you only have 128 cpu entries in MADT, SRAT table should have 128
cpu entries instead of 256 cpu entries
otherwise, RHEL 5.5 could have problem. it will throw away last cpu
entry in SRAT,
 (NR_CPUS is 255..., and last entry still could point the right cpu in MADT)
Also BIOS should keep cpu entries in SRAT have same order to that in MADT.

Thanks

Yinghai
