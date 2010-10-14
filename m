Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755031Ab0JNOlJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 10:41:09 -0400
Received: from g4t0016.houston.hp.com ([15.201.24.19]:26995 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754805Ab0JNOlI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 10:41:08 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH v3 4/6] x86/PCI: allocate space from the end of a region, not the beginning
Date: Thu, 14 Oct 2010 08:39:55 -0600
User-Agent: KMail/1.13.2 (Linux/2.6.32-25-generic; KDE/4.4.2; x86_64; ; )
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, Bob Picco <bpicco@redhat.com>,
        Brian Bloniarz <phunge0@hotmail.com>,
        Charles Butterfield <charles.butterfield@nextcentury.com>,
        Denys Vlasenko <dvlasenk@redhat.com>, linux-pci@vger.kernel.org,
        "Horst H. von Brand" <vonbrand@inf.utfsm.cl>,
        linux-kernel@vger.kernel.org, Stefan Becker <chemobejk@gmail.com>,
        Yinghai Lu <yinghai@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>
References: <20101013161359.28476.6050.stgit@bob.kio> <20101013161526.28476.42395.stgit@bob.kio> <4CB6245E.8080007@zytor.com>
In-Reply-To: <4CB6245E.8080007@zytor.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201010140839.55474.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, October 13, 2010 03:27:58 pm H. Peter Anvin wrote:
> On 10/13/2010 09:15 AM, Bjorn Helgaas wrote:
> >  
> > +#define ALIGN_DOWN(x, a)	((x) & ~(a - 1))
> > -	resource_size_t start = res->start;
> > +	resource_size_t start = ALIGN_DOWN(res->end - size + 1, align);
> >  
> 
> Use round_down() here instead of inventing yet another macro?

Thanks!  I searched for something, but I missed round_down().

Bjorn
