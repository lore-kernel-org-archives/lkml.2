Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756736Ab0I1PSo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 11:18:44 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:58648 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756666Ab0I1PSl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 11:18:41 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH v11 13/17] Add mp(mediate passthru) device.
Date: Tue, 28 Sep 2010 17:18:15 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-16-generic; KDE/4.3.2; x86_64; ; )
Cc: Ben Hutchings <bhutchings@solarflare.com>, xiaohui.xin@intel.com,
        netdev@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, mingo@elte.hu, davem@davemloft.net,
        herbert@gondor.hengli.com.au, jdike@linux.intel.com,
        Sridhar Samudrala <sri@us.ibm.com>
References: <1285388855-27410-1-git-send-email-xiaohui.xin@intel.com> <201009281639.59417.arnd@arndb.de> <20100928144311.GB15294@redhat.com>
In-Reply-To: <20100928144311.GB15294@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201009281718.15813.arnd@arndb.de>
X-Provags-ID: V02:K0:vqSDyROpukhnEbIYwlawrY+wEt5xYskq5VTtGOPPiP0
 NlN4etuOtsTo3wRwJjKDRSUR7nOdiuzE3X6YKh9VwYNDfIujdl
 yxY/XwxRnZt4ehOspiZcLAgzhVayMHrPd25Uw2lr+NbcZYjXyh
 x+JPIaag2AzgJKALGR7azNi10eKs6hvq4K/rxC17+Q9hCPiR7Q
 Yh4SrCJFgZstDzJP8LMPA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 28 September 2010, Michael S. Tsirkin wrote:
> On Tue, Sep 28, 2010 at 04:39:59PM +0200, Arnd Bergmann wrote:
> > Can you be more specific what the problem is? Do you think
> > it breaks when a guest sends VLAN tagged frames or when macvtap
> > is connected to a VLAN interface that adds another tag (or
> > only the combination)?
>
> I expect the protocol value to be wrong when guest sends vlan tagged
> frames as 802.1q frames have a different format.

Ok, I see. Would that be fixed by using eth_type_trans()? I don't
see any code in there that tries to deal with the VLAN tag, so
do we have the same problem in the tun/tap driver?

Also, I wonder how we handle the case where both the guest and
the host do VLAN tagging. Does the host transparently override
the guest tag, or does it add a nested tag? More importantly,
what should it do?

	Arnd
