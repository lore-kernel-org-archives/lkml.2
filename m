Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756645Ab1F1EqO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 00:46:14 -0400
Received: from smtp-out.google.com ([216.239.44.51]:3286 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756185Ab1F1Ene convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 00:43:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=QgmAxxGnyS+3VTLz+hrtgBuh2LL/MNOvLpYMtchL2qwm8YTKGOw9E5Ong+0z+lxhhM
         YjXzRGMTK7nHEoOex8cA==
MIME-Version: 1.0
In-Reply-To: <1308778459.1022.63.camel@twins>
References: <20110621071649.862846205@google.com> <20110621071700.879990875@google.com>
 <1308778459.1022.63.camel@twins>
From: Paul Turner <pjt@google.com>
Date: Mon, 27 Jun 2011 21:43:00 -0700
Message-ID: <CAPM31RLSh38tAchrapdku7yBZLyY+_NrTVCszTFTOLk+rujQ=w@mail.gmail.com>
Subject: Re: [patch 12/16] sched: prevent interactions with throttled entities
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Ingo Molnar <mingo@elte.hu>, Pavel Emelyanov <xemul@openvz.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 22, 2011 at 2:34 PM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> On Tue, 2011-06-21 at 00:17 -0700, Paul Turner wrote:
>> +       udd.cpu = rq->cpu;
>> +       udd.now = rq->clock_task;
>> +       walk_tg_tree_from(cfs_rq->tg, tg_unthrottle_down, tg_nop,
>> +                         (void *)&udd);
>
> How about passing rq along and not using udd? :-)
>

egads.. yes!
