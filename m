Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752889Ab1FNFcP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 01:32:15 -0400
Received: from mail.perches.com ([173.55.12.10]:2960 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751081Ab1FNFcO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 01:32:14 -0400
Subject: Re: [PATCH net-next 1/2] wireless: Remove casts of void *
From: Joe Perches <joe@perches.com>
To: Julian Calaby <julian.calaby@gmail.com>
Cc: netdev@vger.kernel.org, "Luis R. Rodriguez" <lrodriguez@atheros.com>,
        Jouni Malinen <jmalinen@atheros.com>,
        Vasanthakumar Thiagarajan <vasanth@atheros.com>,
        Senthil Balasubramanian <senthilkumar@atheros.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Christian Lamparter <chunkeey@googlemail.com>,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        Wey-Yi Guy <wey-yi.w.guy@intel.com>,
        Intel Linux Wireless <ilw@linux.intel.com>,
        linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net,
        linux-kernel@vger.kernel.org
In-Reply-To: <BANLkTi=i30Rn7gpCDbn9KKJucq8CB=hssA@mail.gmail.com>
References: <cover.1308024069.git.joe@perches.com>
	 <337c22b774ff7f007b90b266b25c9a33ff555c48.1308024069.git.joe@perches.com>
	 <BANLkTi=i30Rn7gpCDbn9KKJucq8CB=hssA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 13 Jun 2011 22:32:12 -0700
Message-ID: <1308029532.26699.68.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-06-14 at 15:23 +1000, Julian Calaby wrote:
> Joe,

Hi Julian.

> On Tue, Jun 14, 2011 at 14:02, Joe Perches <joe@perches.com> wrote:
> > Unnecessary casts of void * clutter the code.
> > These are the remainder casts after several specific
> > patches to remove netdev_priv and dev_priv.
> You seem to have removed a lot of casts that don't relate to these cleanups.
> In particular, some of the casts seem to relate more to documentation
> rather than just changing pointer types to make the compiler happy.

All of the cast removals are casts of void* types.
I think none of of the casts are useful.
None of them are required, all are duplicative.

> In
> particular, I'm referring to the casts describing the different usages
> of data_buf in mwiflex, and around some pointer math in ath9k.

Can you describe more in detail why you think these are documentary?

This sort of cast:

diff --git a/drivers/net/wireless/mwifiex/11n.c b/drivers/net/wireless/mwifiex/11n.c
@@ -191,7 +191,7 @@ int mwifiex_ret_11n_cfg(struct host_cmd_ds_command *resp, void *data_buf)
 	struct host_cmd_ds_11n_cfg *htcfg = &resp->params.htcfg;
 
 	if (data_buf) {
-		tx_cfg = (struct mwifiex_ds_11n_tx_cfg *) data_buf;
+               tx_cfg = data_buf;

I think pretty useless.  tx_cfg is a struct mwifiex_ds_11n_tx_cfg *.

> Whilst I'm sure that the compiler is smart enough to handle automatic
> casts between pointer types, some of these, in particular the mwiflex
> bits, add some documentation to the code.

I think not.  Opinions of course can vary.

cheers, Joe

