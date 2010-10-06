Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756183Ab0JFE72 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 00:59:28 -0400
Received: from smtp109.sbc.mail.mud.yahoo.com ([68.142.198.205]:41994 "HELO
	smtp109.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755255Ab0JFE70 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 00:59:26 -0400
X-Yahoo-SMTP: fzDSGlOswBCWnIOrNw7KwwK1j9PqyNbe5PtLKiS4dDU.UNl_t6bdEZu9tTLW
X-YMail-OSG: QJDmOt8VM1kvxqPScUiipa.X08sLpl5w9lpduEAg93fiA7v
 1IqCB.Q93sUD48lJRDsPXtX_jslApt0SOYO0UnsgbbstdlGRfUS_CtFc2meC
 4nEXd_zNRfYkvtdIOGUojyBfOzeqXhAdwK_52rnFEEhLkv6LdGgtxDrq1E2o
 hvyUyWuKBgkYk00mGslpV_RAKCpOIcstgrItlKpQ_GF6xw.J9fUm.rfa3Fpa
 u5hkwnSeMAha1us_c8YAzHBQz.v5L40iA9ZxWdiweVK1wt5MHTG2wvCq0J_U
 DPRK5Vm3lASxGkSVpt2ltCJqvY_JHdUJ0JvLWn5CY5akFX8tKR94-
X-Yahoo-Newman-Property: ymail-3
Subject: Re: [RFC v2 06/21] tcm: Add fabric and subsystem transport engine
	core
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        michaelc@cs.wisc.edu, hch@lst.de, hare@suse.de,
        James.Bottomley@suse.de, axboe@kernel.dk, bharrosh@panasas.com
In-Reply-To: <20101006113150S.fujita.tomonori@lab.ntt.co.jp>
References: <1285195763-11535-1-git-send-email-nab@linux-iscsi.org>
	 <20101006113150S.fujita.tomonori@lab.ntt.co.jp>
Content-Type: text/plain
Date: Tue, 05 Oct 2010 21:54:47 -0700
Message-Id: <1286340887.5685.102.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-10-06 at 11:36 +0900, FUJITA Tomonori wrote:
> On Wed, 22 Sep 2010 15:49:23 -0700
> "Nicholas A. Bellinger" <nab@linux-iscsi.org> wrote:
> 
> > From: Nicholas Bellinger <nab@linux-iscsi.org>
> > 
> > The patch adds core generic target engine functionality including processing of struct se_cmd
> > generation of N struct se_task, control CDB emulation, sense data, memory allocation, and
> > and mapping from fabric module allocated memory using linked list struct scatterlist
> > style memory based on the limitiations of the underlying TCM HBA and Device backstores.
> > 
> > The TCM layer sits is above Linux/SCSI, Linux/BLOCK and Linux/VFS subsystems, and
> > communicates with these subsystems (and local RAMDISK plugins) using an API of function
> > pointers in se_subsystem_api_t.  It provides processing capabilties and emulation for SCSI
> > logic and CDBs in a generic manner to storage object LUNs provided from Linux storage
> > subsystems backend storage devices.
> > 
> > Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
> > ---
> >  drivers/target/target_core_scdb.c      |  158 +
> >  drivers/target/target_core_scdb.h      |   15 +
> >  drivers/target/target_core_transport.c | 8860 ++++++++++++++++++++++++++++++++
> >  include/target/target_core_transport.h |  570 ++
> >  4 files changed, 9603 insertions(+), 0 deletions(-)
> >  create mode 100644 drivers/target/target_core_scdb.c
> >  create mode 100644 drivers/target/target_core_scdb.h
> >  create mode 100644 drivers/target/target_core_transport.c
> >  create mode 100644 include/target/target_core_transport.h
> 
> Can a driver cleanly overwrite cmd->transport_emulate_cdb? ibmvscsi
> target driver needs to the specific responses for INQUIRY and
> REPORT_LUNS.
> 

Hmmmmmm..  Currently the optional cmd->transport_emulate_cdb()
assignment is done from TCM internal code for things like PR and ALUA
CDB emulation, but I cannot see a reason why something similar could not
be exported out into TCM fabric module code with a bit of work.

> I guess that the driver can ignore the response buffer from tcm and
> create the own but it would be nice if the driver can do cleanly.
> --

<nod>, makes perfect sense to me..

Also just FYI, hch has been prodding me to unify the current per
subsystem backstore logic for [iblock,fd,rd,stgt]_emulate_scsi_cdb() and
make any specific CDB emulation that requires non generic code use a CDB
specific struct se_subsystem_api function pointer.  I will be looking at
doing this in the next days, and I will see what what can be done for an
patch w/ example case for TCM_Loop to allow CDB context emulation to be
done via the TCM fabric module struct target_core_fabric_ops API.

Thanks Tomo-san!

--nab

