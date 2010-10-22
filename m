Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759623Ab0JVTnl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 15:43:41 -0400
Received: from web33003.mail.mud.yahoo.com ([209.191.69.118]:20428 "HELO
	web33003.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1759128Ab0JVTnk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 15:43:40 -0400
X-Greylist: delayed 398 seconds by postgrey-1.27 at vger.kernel.org; Fri, 22 Oct 2010 15:43:40 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type;
  b=jOMGSgh5BSK7oaqkyjTCvSKFEvrfIT10E4f0SZeB5Ze+xilJAYQas8VB5qh7znOPTboP11oADN0cSCxLrKplIBg2TICgSuuS2nSanJTco9I+P5CDZtovuq2vWIRIoz4THfS0gYH97EUqv1vFk3GQGRE8r+NAUVsAKnG4ZGoJ0UU=;
Message-ID: <402956.74986.qm@web33003.mail.mud.yahoo.com>
X-YMail-OSG: nFiGVVQVM1k3.F8A6fIXAIJiDcM5BPJD5gxjrQhCTrq9BWp
 .aGyvY_GYKcNEj1Daasg1G48rtdaxmkiYEspGV4_CwT9Vdt2PmyDdmLb0YQa
 2X4acyEcMTw7HKKTN9RXHQkT56rZYxxi87aQnmBNbnh.7pO0DbK4Vd6kfV7N
 NfTEQWLeOdZke6QbQ.Uy2CtSmLYpCuuXDHRYJnM3WNXxh8AYEemMxOn.LGML
 tRi7_cAdu.5spQH4zmXgdpbo6qEtrhSK4fhReXUWo6vpW7P96UQRH_.Eor0g
 .nvpIFaXRyoXPtYnPvO9YL0PrbGTWNXmr8QB4y6DQG_kwy1twijTiZkPaJdp
 4pQyAVbToxbKk.6H95s6o_gYLbiw1dVfkibf78CO7NS8RzmWj
X-Mailer: YahooMailClassic/11.4.9 YahooMailWebService/0.8.107.284920
Date: Fri, 22 Oct 2010 12:36:59 -0700 (PDT)
From: Stephen Cameron <smcameron@yahoo.com>
Subject: Re: [PATCH 3/5] cciss: Use kernel provided PCI state save and restore functions
To: axboe@kernel.dk, "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        mike.miller@hp.com, thenzl@redhat.com
In-Reply-To: <20101022192112.25567.24572.stgit@beardog.cce.hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--- On Fri, 10/22/10, Stephen M. Cameron <scameron@beardog.cce.hp.com> wrote:

> From: Stephen M. Cameron <scameron@beardog.cce.hp.com>
> Subject: [PATCH 3/5] cciss: Use kernel provided PCI state save and restore functions
> To: axboe@kernel.dk
> Cc: akpm@linux-foundation.org, smcameron@yahoo.com, linux-kernel@vger.kernel.org, mike.miller@hp.com, thenzl@redhat.com
> Date: Friday, October 22, 2010, 2:21 PM
> From: Stephen M. Cameron <scameron@beardog.cce.hp.com>
> 
> and use the doorbell reset method if available (which doesn't
> lock up the controller if you properly save and restore
> all the PCI registers that you're supposed to.)


This patch, and all these cciss patches in this series, are vs. the jens/for-2.6.37/drivers branch.

One difference I noticed between linux-2.6.36 and jens/for-2.6.37/drivers is that linux-2.6.36 contains this in drivers/block/cciss.c
in the function cciss_kdump_hard_reset_controller:

        /* The doorbell reset seems to cause lockups on some Smart
         * Arrays (e.g. P410, P410i, maybe others).  Until this is
         * fixed or at least isolated, avoid the doorbell reset.
         */
        use_doorbell = 0;

This is not present in jens/for-2.6.37/drivers.

That was added to linus tree by me, because I'd noticed we were getting controller lockups and subsequent data corruption when attempting kdumps using the doorbell reset when (unbeknownst to me at the time) the pci state saving and restoring code wasn't quite right.  So these patches fix the pci state saving and restoring code, so the above "use_doorbell = 0" needs to come out when these patches go into Linus's tree.  But such a patch cannot be made vs. Jens's tree, because that code isn't in Jens's tree.

-- steve



      
