Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752719Ab1GRH1U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 03:27:20 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:45234 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752586Ab1GRH1S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 03:27:18 -0400
User-Agent: Microsoft-Entourage/12.30.0.110427
Date: Mon, 18 Jul 2011 08:27:06 +0100
Subject: Re: [Xen-devel] [PATCH] xen: update machine_to_phys_order on resume
From: Keir Fraser <keir.xen@gmail.com>
To: Jan Beulich <JBeulich@novell.com>, <Ian.Campbell@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, <keir@xen.org>
CC: <olaf@aepfle.de>, <xen-devel@lists.xensource.com>,
        <linux-kernel@vger.kernel.org>
Message-ID: <CA499EDA.1E10E%keir.xen@gmail.com>
Thread-Topic: [Xen-devel] [PATCH] xen: update machine_to_phys_order on resume
Thread-Index: AcxFHBiKppVrRXHQekynmz773MeOdA==
In-Reply-To: <4E23F76D020000780004DCD9@nat28.tlf.novell.com>
Mime-version: 1.0
Content-type: text/plain;
	charset="US-ASCII"
Content-transfer-encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18/07/2011 08:05, "Jan Beulich" <JBeulich@novell.com> wrote:

>>>> On 15.07.11 at 20:23, Keir Fraser <keir.xen@gmail.com> wrote:
>> On 15/07/2011 18:30, "Jan Beulich" <JBeulich@novell.com> wrote:
>> 
>>> Actually, one more thought: What's the purpose of this hypercall if
>>> it is set in stone what values it ought to return? Isn't a guest using
>>> it (supposed to be) advertising that it can deal with the values being
>>> variable (and it was just overlooked so far that this doesn't only
>>> include varying values from boot to boot, but also migration)? Or in
>>> other words, if we found a need to relocate the M2P table or grow
>>> its static maximum size, it would be impossible to migrate guests
>>> from an old to a new hypervisor.
>> 
>> Fair point. There has to be a static fallback set of return values for old
>> guests.
> 
> Hmm, in my reading the two sentences sort of contradict each other.
> That is, I'm not certain what route we want to go here: Keep things
> the way they are after 23706:3dd399873c9e, and introduce a
> completely new discovery mechanism if we find it necessary to change
> the M2P table's location and/or size, including a mechanism for a guest
> to announce it's capable of dealing with that? If so, I think we ought
> to add a comment to the hypercall implementation documenting that
> its return values must not be changed (and why).

We can return different values from the existing hypercall if that is
negotiated with the guest, at run time or build time.

 -- Keir

> Jan
> 


