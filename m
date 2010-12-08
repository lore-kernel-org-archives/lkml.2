Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932423Ab0LHBwn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 20:52:43 -0500
Received: from mail-iw0-f172.google.com ([209.85.214.172]:38651 "EHLO
	mail-iw0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932068Ab0LHBwk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 20:52:40 -0500
X-Greylist: delayed 492 seconds by postgrey-1.27 at vger.kernel.org; Tue, 07 Dec 2010 20:52:40 EST
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=i8T2WKf27T8YDKJivVdBGDz0uSjunCwl5M8LiQR0dxn/lTr2S/q6Yb0rlOj5PE5pm/
         rNfcwyGVzPxo4bie0WdBzHrTSG2L6Zuj9a0ROwxAhPEt18h00lt9s2aUJOngINdlxGt/
         klya/alBlPn2CA0HIzoQorEAMcntOCyS0crl8=
Message-ID: <4CFEE2F9.90600@gmail.com>
Date: Tue, 07 Dec 2010 19:44:25 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101103 Fedora/1.0-0.33.b2pre.fc14 Thunderbird/3.1.6
MIME-Version: 1.0
To: =?UTF-8?B?UGF3ZcWCIFNpa29yYQ==?= <pluto@agmk.net>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [2.6.36.1] IGB driver handles all ethX interrupts on single cpu
 core.
References: <201012071906.47161.pluto@agmk.net>
In-Reply-To: <201012071906.47161.pluto@agmk.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/07/2010 12:06 PM, Paweł Sikora wrote:
> hi,
>
> i'm currently testing a new server with 2x opteron-6128 with dual gigabit port
> and observing that the igb driver uses only single core for all ethX interrupts.
> is it a correct behaviour for this driver?
>
> BR,
> Pawel.

The CPU affinity for the IRQ isn't really under the driver's control. It 
looks like all your interrupts are being handled on CPU0. You likely 
need to run the irqbalance daemon.
