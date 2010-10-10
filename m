Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752290Ab0JJNlN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Oct 2010 09:41:13 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:39585 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751246Ab0JJNlM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Oct 2010 09:41:12 -0400
Date: Sun, 10 Oct 2010 15:07:13 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Huang Ying <ying.huang@intel.com>
Cc: Don Zickus <dzickus@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Andi Kleen <andi@firstfloor.org>,
        Robert Richter <robert.richter@amd.com>
Subject: Re: [PATCH -v3 5/6] x86, NMI, treat unknown NMI as hardware error
Message-ID: <20101010150713.3cd3eed2@lxorguk.ukuu.org.uk>
In-Reply-To: <1286606987-19879-5-git-send-email-ying.huang@intel.com>
References: <1286606987-19879-1-git-send-email-ying.huang@intel.com>
	<1286606987-19879-5-git-send-email-ying.huang@intel.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat,  9 Oct 2010 14:49:46 +0800
Huang Ying <ying.huang@intel.com> wrote:

> In general, unknown NMI is used by hardware and firmware to notify
> fatal hardware errors to OS. So the Linux should treat unknown NMI as
> hardware error and go panic upon unknown NMI for better error
> containment.

Not entirely true. Older machines use NMI for all sorts of interesting
purposes. In particular many 486 laptops trigger NMI as part of power
manaagement, (Hence the choice of the dazed and confused message)

> But there are some broken hardware, which will generate unknown NMI
> not for hardware error. To support these machines, a white list

"Broken" is not the right term. There is no formal documentation about
such uses of NMI on older PC platforms that forbids such use. They may not
agree with your personal preferred behaviour.

> These systems are identified via the presentation of APEI HEST or
> some PCI ID of the host bridge. The PCI ID of host bridge instead of
> DMI ID is used, so that the checking can be done based on the platform
> type instead of motherboard. This should be simpler and sufficient.
> 
> The method to identify the platforms is designed by Andi Kleen.

Why not make the new flag also a boot option so you can force it on for
platforms where we don't auto whitelist it.

Alan


