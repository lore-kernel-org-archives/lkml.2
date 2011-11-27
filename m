Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752438Ab1K0JnU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Nov 2011 04:43:20 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:52568 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751153Ab1K0JnR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Nov 2011 04:43:17 -0500
MIME-Version: 1.0
In-Reply-To: <CANUX_P2mGQX9H-f7OFusjUrv8ey56JNzFVEdKJkAejsg9zVNkQ@mail.gmail.com>
References: <20111122072730.GA32225@gamma.logic.tuwien.ac.at>
	<CANUX_P15En9bHVx4bhq6=XKPZnC2u+QyVJ+jnm4ns=39DrOBtg@mail.gmail.com>
	<2D0C7905-AEB2-4DE4-89B1-945D89F2B5D6@logic.at>
	<CANUX_P21PDdyo4u-x_1A0Lcqf-33yHgzUxddAoc3juGRNnrcDg@mail.gmail.com>
	<20111122124357.GA32440@gamma.logic.tuwien.ac.at>
	<CANUX_P0uyyuK4netV6srYCh9FsC4cpGzxobHE3T38n5RvvA0RQ@mail.gmail.com>
	<20111123015503.GC23203@gamma.logic.tuwien.ac.at>
	<CANUX_P1zDDzMy5yrFXSZAkMQ-87uu-fE1e-2sCEgHJi4dh5eiw@mail.gmail.com>
	<20111125122143.GA30404@gamma.logic.tuwien.ac.at>
	<CANUX_P1hFzSVPQzd6gq3tLY7hu+LX5suph6uHP+hq6+7rdAK1w@mail.gmail.com>
	<20111125123720.GA31564@gamma.logic.tuwien.ac.at>
	<CANUX_P2mGQX9H-f7OFusjUrv8ey56JNzFVEdKJkAejsg9zVNkQ@mail.gmail.com>
Date: Sun, 27 Nov 2011 11:43:16 +0200
Message-ID: <CANUX_P1aAz-4TpgSzQ2G=RkJOxXCAVQBja3GNsj_HpMNmqxeUw@mail.gmail.com>
Subject: Re: iwlagn is getting very shaky
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: Norbert Preining <preining@logic.at>
Cc: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>,
        David Rientjes <rientjes@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ipw3945-devel@lists.sourceforge.net" 
	<ipw3945-devel@lists.sourceforge.net>,
        "ilw@linux.intel.com" <ilw@linux.intel.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>, Dave Jones <davej@redhat.com>
Content-Type: multipart/mixed; boundary=0016e6de03e22c1a1a04b2b4373f
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--0016e6de03e22c1a1a04b2b4373f
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi again

Can you please try the attached patch ?
I would like to know if it helps.

Thanks !

On Sun, Nov 27, 2011 at 08:38, Emmanuel Grumbach <egrumbach@gmail.com> wrot=
e:
>> Yeah, that was my impression too, but still, I wanted to mention it.
>>
>>> I am already on week-end here and will look at it more carefully
>>> later. First impression is that things are messy here. I guess we are
>>> getting in a bad failure path that wasn't checked...
>>
>> No problem, I can cope with it.
>>
>
> you can always disable 11n: modprobe 11n_disable=3D1.
>
> Well... Something is really weird here:
> mac80211 requests from us to:
> * start agg
> * stop agg
> * agg operational
>
> this is not a legal sequence
>
> BTW - I am under this impression that mac80211 hasn't been compiled
> with HT debug flag. Can you please set this compilation flag ?
>
> I also would like you to add this line in iwlagn_mac_ampdu_action:
>
>
> static int iwlagn_mac_ampdu_action(struct ieee80211_hw *hw,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struc=
t ieee80211_vif *vif,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 enum =
ieee80211_ampdu_mlme_action action,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struc=
t ieee80211_sta *sta, u16 tid, u16 *ssn,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 u8 bu=
f_size)
> {
> =A0 =A0 =A0 =A0struct iwl_priv *priv =3D hw->priv;
> =A0 =A0 =A0 =A0int ret =3D -EINVAL;
> =A0 =A0 =A0 =A0struct iwl_station_priv *sta_priv =3D (void *) sta->drv_pr=
iv;
>
> =A0 =A0 =A0 =A0IWL_DEBUG_HT(priv, "A-MPDU action on addr %pM tid %d\n",
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 sta->addr, tid);
>
> dump_stack(); =A0 <<<<=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D ne=
w line
>
> =A0 =A0 =A0 =A0if (!(priv->cfg->sku & EEPROM_SKU_CAP_11N_ENABLE))
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return -EACCES;
>
>
>
> This will give an insight at why is mac80211 calling the driver and
> better point me to the bug.
>
>
> Thanks !
>

--0016e6de03e22c1a1a04b2b4373f
Content-Type: text/x-patch; charset=US-ASCII; name="addba_timer_fix.patch"
Content-Disposition: attachment; filename="addba_timer_fix.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gvhv0cv60

ZGlmZiAtLWdpdCBhL25ldC9tYWM4MDIxMS9hZ2ctdHguYyBiL25ldC9tYWM4MDIxMS9hZ2ctdHgu
YwppbmRleCBkOWI1MzQwLi5mNjQzNmI5IDEwMDY0NAotLS0gYS9uZXQvbWFjODAyMTEvYWdnLXR4
LmMKKysrIGIvbmV0L21hYzgwMjExL2FnZy10eC5jCkBAIC03NzgsNiArNzc4LDkgQEAgdm9pZCBp
ZWVlODAyMTFfcHJvY2Vzc19hZGRiYV9yZXNwKHN0cnVjdCBpZWVlODAyMTFfbG9jYWwgKmxvY2Fs
LAogCSAqLwogCWlmIChsZTE2X3RvX2NwdShtZ210LT51LmFjdGlvbi51LmFkZGJhX3Jlc3Auc3Rh
dHVzKQogCQkJPT0gV0xBTl9TVEFUVVNfU1VDQ0VTUyAmJiBidWZfc2l6ZSkgeworCQlpZiAodGVz
dF9iaXQoSFRfQUdHX1NUQVRFX1dBTlRfU1RPUCwgJnRpZF90eC0+c3RhdGUpKQorCQkJLyogdGhl
IGFkZEJBIHJlc3AgY2FtZSB0b28gbGF0ZSAqLworCQkJZ290byBvdXQ7CiAJCWlmICh0ZXN0X2Fu
ZF9zZXRfYml0KEhUX0FHR19TVEFURV9SRVNQT05TRV9SRUNFSVZFRCwKIAkJCQkgICAgICZ0aWRf
dHgtPnN0YXRlKSkgewogCQkJLyogaWdub3JlIGR1cGxpY2F0ZSByZXNwb25zZSAqLwo=
--0016e6de03e22c1a1a04b2b4373f--
