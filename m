Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755954Ab0EaDtj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 May 2010 23:49:39 -0400
Received: from smtp127.sbc.mail.sp1.yahoo.com ([69.147.65.186]:27936 "HELO
	smtp127.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755853Ab0EaDth (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 May 2010 23:49:37 -0400
X-Yahoo-SMTP: fzDSGlOswBCWnIOrNw7KwwK1j9PqyNbe5PtLKiS4dDU.UNl_t6bdEZu9tTLW
X-YMail-OSG: C_0EvtYVM1nOm2NPTF0GvuAEPmHflTVgoKNTIX4Wm5gYJKTp5qaucw_d89lwgqbSN4ynk6Tx9tGA7tRA0qeCecOG95ff_SNVrtpD3IaEHOX0N07nT2EzqpL1r6bPCEG_iIlbyPe5gVhedWDTYvK.IjYqvmTjIDd9rzq.xqfv9g8ZjeoasvQBJ3Rg.fVWZi7xu2QMAexBfH81ZBu38iMxJmLN8MMnypA9R4fHVIbMlLZpC_FHVENCa3Q5Avq.u_vUPNY.Ts.6kntF6mP71298lHhWKVDp4tjzaVQjZn5b20yk6iaRAV_J8nInp4Ex1RmtkzXmMdbfrfRdXnBtUhHRYQB8XuIHxQkKal9dmZ7dqReX7A--
X-Yahoo-Newman-Property: ymail-3
Subject: Re: [RFC]: Mainline of TCM Core and TCM_Loop for v2.6.35
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: James Bottomley <James.Bottomley@suse.de>,
       Christoph Hellwig <hch@infradead.org>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Mike Christie <michaelc@cs.wisc.edu>, Douglas@firstfloor.org,
       Gilbe@firstfloor.org, linux-scsi <linux-scsi@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <87vda5zqm9.fsf@basil.nowhere.org>
References: <1274317792.30733.59.camel@haakon2.linux-iscsi.org>
	 <87vda5zqm9.fsf@basil.nowhere.org>
Content-Type: text/plain
Date: Sun, 30 May 2010 20:47:04 -0700
Message-Id: <1275277624.32585.88.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-05-30 at 11:27 +0200, Andi Kleen wrote:
> "Nicholas A. Bellinger" <nab@linux-iscsi.org> writes:
> >
> > As always, I am open to constructive suggestions,
> 

Greetings Andi,

> Your description contains quite a lot of acronyms (I count 8 in the first
> paragraph alone). For the benefit of the linux-kernel audience which are
> not storage experts and are struggling to find out what this is all good
> for, how about including a glossary that explains what it all means?  I
> suspect having that in the git commit log later will be also useful.
> 

Point taken on a glossary + storage decoder ring..  Being able to open
up the discussion to a wider kernel audience is a really good thing I
think. ;)

Also, one major item on my TODO list is to publish a fabric plugin
'cookbook' for creating your very own TCM target mode fabric module with
a fully functioning configfs control plane.  This will initially involve
a walkthough of the required logic to get up and running for new fabric
module developers.

However, what I would like to eventually do with the mainline TCM code
is to provide a single example fabric module + script for generating N
new base TCM fabric modules with a fully functioning v4 configfs fabric
shell.  This script would generate code with sed-fu based on a supplied
fabric plugin name and supported SCSI ProtocolIDs (eg: SAS, FC, iSCSI,
etc) using existing TCM v4 world wide port name (WWPN) emulation logic
located in drivers/target/target_core_fabric_lib.c.

The latter WWPN emulation bit is what allows SPC-4 features like
persistent reservation (PR), asymmetric logical unit access (ALUA) to
work right out of the box for a newly generated TCM v4 fabric plugin
today.  This is what has been included in new base code for tcm_lpfc,
tcm_qla2xxx and tcm_mvsas modules and recently posted to linux-scsi.

Anyways, the ability generate a base kernel fabric module you can
actually build, load and configure it's new TCM configfs fabric shell
would be pretty cool and would certainly be a big help for new
developers too.

Thanks for your comments Andi!

Best,

--nab

