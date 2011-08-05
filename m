Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754655Ab1HERLJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 13:11:09 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33021 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751428Ab1HERLG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 13:11:06 -0400
Message-ID: <4E3C2405.8090309@zytor.com>
Date: Fri, 05 Aug 2011 10:10:29 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110707 Thunderbird/5.0
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, Avi Kivity <avi@redhat.com>,
        Andre Przywara <Andre.Przywara@amd.com>,
        Martin Pohlack <Martin.Pohlack@amd.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: Re: [PATCH -v3.1 0/3] x86, AMD: Correct F15h IC aliasing issue
References: <1312550110-24160-1-git-send-email-bp@amd64.org>
In-Reply-To: <1312550110-24160-1-git-send-email-bp@amd64.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/05/2011 06:15 AM, Borislav Petkov wrote:
> From: Borislav Petkov <borislav.petkov@amd.com>
> 
> Hi,
> 
> a small refinement of the patchset from yesterday per hpa's comments:
> 
> * put mask and flags into a single cacheline and make it __read_mostly
> 
> * change alignment computation back to clearing bits [14:12] so that a
> mask of 0x0 can have no effect on the address.
> 
> Please take a look and apply, if no objections.
> 

Patch 1 looks good now.

Patch 2 I'm going to object to because it puts your run_on_bsp method
into a different structure where all the existing methods for this
already are in a way that looks totally gratuitous to me.  Why not just
have a c_bsp_init on struct cpu_dev like all the other methods?

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

