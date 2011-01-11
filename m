Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752033Ab1AKFWH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 00:22:07 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:46191 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751905Ab1AKFWD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 00:22:03 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1101102211370.12076@xanadu.home>
References: <20110111015409.18291.87166.stgit@localhost6.localdomain6> <alpine.LFD.2.00.1101102211370.12076@xanadu.home>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Mon, 10 Jan 2011 22:21:42 -0700
X-Google-Sender-Auth: oLGBINCQes1uoMuPQ5CARsOJkMw
Message-ID: <AANLkTimBOJUVx1eqsTQmmmPm4v=K2b_BGyrsV-YR45fu@mail.gmail.com>
Subject: Re: [RFC] arm: Defer lookup of machine_type and vet of atags to setup.c
To: Nicolas Pitre <nico@fluxnic.net>
Cc: Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Jeremy Kerr <jeremy.kerr@canonical.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 10, 2011 at 8:19 PM, Nicolas Pitre <nico@fluxnic.net> wrote:
> On Mon, 10 Jan 2011, Grant Likely wrote:
>
>> Since the debug macros no longer depend on the machine type
>> information, both the machine type lookup and the atags vetting can be
>> deferred to setup_arch() in setup.c which simplifies the code
>> somewhat.
>>
>> This patch removes both __machine_type_lookup and __vet_atags() from
>> head.S.  The atags vetting is moved to setup_arch().  machine_type
>> lookup is already called from setup_machine() in addition to where it
>> was called from head.S.
>
> While at it, you could also remove the code for __lookup_machine_type,
> lookup_machine_type and __error_a, replacing that with a C
> implementation living in setup.c instead.  If this code is not called
> from head.S anymore, there is no reason to keep it there any longer.

Certainly.  I'll draft that up as a separate patch and post it tomorrow.

g.
