Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752935Ab1FNFjz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 01:39:55 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:42040 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751342Ab1FNFjw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 01:39:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=cQAw1u1ZBm98O13UHsj9/mKvoiORHNMnrWsH4vxyzys7+HR+QpfAmuDfUXgEpoKrB3
         0QT37qEeGG6FpK+OF2/xefconkdAevx9bUFrXr+aim25WoE9qnThziiQTURuPffWVhj2
         u1nodcaw0ZAKtQflk7UflXoSxAKQW3aZrs7Tw=
MIME-Version: 1.0
In-Reply-To: <1308029532.26699.68.camel@Joe-Laptop>
References: <cover.1308024069.git.joe@perches.com> <337c22b774ff7f007b90b266b25c9a33ff555c48.1308024069.git.joe@perches.com>
 <BANLkTi=i30Rn7gpCDbn9KKJucq8CB=hssA@mail.gmail.com> <1308029532.26699.68.camel@Joe-Laptop>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Tue, 14 Jun 2011 15:39:32 +1000
Message-ID: <BANLkTik4fWbCc8pRZfKCzvKD2f6sK9QCEw@mail.gmail.com>
Subject: Re: [PATCH net-next 1/2] wireless: Remove casts of void *
To: Joe Perches <joe@perches.com>
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
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe,

On Tue, Jun 14, 2011 at 15:32, Joe Perches <joe@perches.com> wrote:
> On Tue, 2011-06-14 at 15:23 +1000, Julian Calaby wrote:
>> Joe,
>
> Hi Julian.
>
>> On Tue, Jun 14, 2011 at 14:02, Joe Perches <joe@perches.com> wrote:
>> > Unnecessary casts of void * clutter the code.
>> > These are the remainder casts after several specific
>> > patches to remove netdev_priv and dev_priv.
>> You seem to have removed a lot of casts that don't relate to these cleanups.
>> In particular, some of the casts seem to relate more to documentation
>> rather than just changing pointer types to make the compiler happy.
>
> All of the cast removals are casts of void* types.
> I think none of of the casts are useful.
> None of them are required, all are duplicative.

My issue here is that you mention in the commit log that this relates
to the removal of netdev_priv and dev_priv, but the casts removed
(mostly) don't.

>> In
>> particular, I'm referring to the casts describing the different usages
>> of data_buf in mwiflex, and around some pointer math in ath9k.
>
> Can you describe more in detail why you think these are documentary?
>
> This sort of cast:
>
> diff --git a/drivers/net/wireless/mwifiex/11n.c b/drivers/net/wireless/mwifiex/11n.c
> @@ -191,7 +191,7 @@ int mwifiex_ret_11n_cfg(struct host_cmd_ds_command *resp, void *data_buf)
>        struct host_cmd_ds_11n_cfg *htcfg = &resp->params.htcfg;
>
>        if (data_buf) {
> -               tx_cfg = (struct mwifiex_ds_11n_tx_cfg *) data_buf;
> +               tx_cfg = data_buf;
>
> I think pretty useless.  tx_cfg is a struct mwifiex_ds_11n_tx_cfg *.

True, but IMHO, this documents, particularly in a random snippet like
this, what's going on. Arguably though, a better fix would be to move
the cast to the place where this function is called.

>> Whilst I'm sure that the compiler is smart enough to handle automatic
>> casts between pointer types, some of these, in particular the mwiflex
>> bits, add some documentation to the code.
>
> I think not.  Opinions of course can vary.

Of course. I rarely look at full files, so the more information that
can be stuffed into a patch, the better for me. That said, I agree
that all the casts removed are superfluous.

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/
