Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754371Ab2CGJcp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 04:32:45 -0500
Received: from nat28.tlf.novell.com ([130.57.49.28]:19835 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750934Ab2CGJcm convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:13:1>);
	Wed, 7 Mar 2012 04:32:42 -0500
Message-Id: <4F5739760200007800076DA6@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Wed, 07 Mar 2012 09:33:26 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: "Santosh Jodh" <Santosh.Jodh@citrix.com>, <konrad@darnok.org>
Cc: "David Vrabel" <david.vrabel@citrix.com>,
        "Ian Campbell" <Ian.Campbell@citrix.com>,
        "Paul Durrant" <Paul.Durrant@citrix.com>,
        "waldi@debian.org" <waldi@debian.org>,
        "weiyi.huang@gmail.com" <weiyi.huang@gmail.com>,
        "jeremy@goop.org" <jeremy@goop.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>,
        "xen-devel@lists.xen.org" <xen-devel@lists.xen.org>,
        "joe.jin@oracle.com" <joe.jin@oracle.com>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "lersek@redhat.com" <lersek@redhat.com>,
        "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>,
        "dgdegra@tycho.nsa.gov" <dgdegra@tycho.nsa.gov>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>,
        "paul.gortmaker@windriver.com" <paul.gortmaker@windriver.com>
Subject: Re: [Xen-devel] [PATCH 0001/001] xen: multi page ring support
 for block devices
References: <1330701099-18281-1-git-send-email-santoshprasadnayak@gmail.com>
 <7914B38A4445B34AA16EB9F1352942F1010A1FA12364@SJCPMAILBOX01.citrite.net>
 <CAPbh3rsExLtohBwVd_scYuO=GN1iZE5egQQ3x5M59YUno5Rtyw@mail.gmail.com>
In-Reply-To: <CAPbh3rsExLtohBwVd_scYuO=GN1iZE5egQQ3x5M59YUno5Rtyw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 06.03.12 at 18:20, Konrad Rzeszutek Wilk <konrad@darnok.org> wrote:
>  -> the usage of XenbusStateInitWait? Why do we introduce that? Looks
> like a fix to something.

No, this is required to get the negotiation working (the frontend must
not try to read the new nodes until it can be certain that the backend
populated them). However, as already pointed out in an earlier reply
to Santosh, the way this is done here doesn't appear to allow for the
backend to already be in InitWait state when the frontend gets
invoked.

> -> XENBUS_MAX_RING_PAGES - why 2? Why not 4? What is the optimal
> default size for SSD usage? 16?

What do SSDs have to do with a XenBus definition? Imo it's wrong (and
unnecessary) to introduce a limit at the XenBus level at all - each driver
can do this for itself.

As to the limit for SSDs in the block interface - I don't think the number
of possibly simultaneous requests has anything to do with this. Instead,
I'd expect the request number/size/segments extension that NetBSD
apparently implements to possibly have an effect.

Jan

