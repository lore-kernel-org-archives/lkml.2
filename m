Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932166Ab0CaWfz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 18:35:55 -0400
Received: from claw.goop.org ([74.207.240.146]:43364 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755817Ab0CaWfy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 18:35:54 -0400
Message-ID: <4BB3CE46.1050105@goop.org>
Date: Wed, 31 Mar 2010 15:35:50 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Lightning/1.0b2pre Thunderbird/3.0.3
MIME-Version: 1.0
To: Colin King <colin.king@canonical.com>
CC: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: Disable 4MB page tables for Atom, work around errata
 AAE44
References: <1269271251-19775-1-git-send-email-colin.king@canonical.com>
In-Reply-To: <1269271251-19775-1-git-send-email-colin.king@canonical.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/22/2010 08:20 AM, Colin King wrote:
> "If software clears the PS (page size) bit in a present PDE (page directory
> entry), that will cause linear addresses mapped through this PDE to use
> 4-KByte pages instead of using a large page after old TLB entries are
> invalidated. Due to this erratum, if a code fetch uses this PDE before the
> TLB entry for the large page is invalidated then it may fetch from a different
> physical address than specified by either the old large page translation or
> the new 4-KByte page translation. This erratum may also cause speculative code
> fetches from incorrect addresses."
>    

Does this only affect non-PAE 32-bit?  Or does it also affect 3 and 4 
level pagetables with 2MB large pages?

     J
