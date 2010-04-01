Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757698Ab0DACAF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 22:00:05 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:46524 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755237Ab0DAB76 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 21:59:58 -0400
Date: Thu, 1 Apr 2010 12:59:44 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       "Wey-Yi Guy" <wey-yi.w.guy@intel.com>,
       Reinette Chatre <reinette.chatre@intel.com>
Subject: linux-next: manual merge of the wireless tree with the
 wireless-current tree
Message-Id: <20100401125944.54adc73c.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.1 (GTK+ 2.18.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__1_Apr_2010_12_59_44_+1100_q7vlz+m6A.SGxWbA"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__1_Apr_2010_12_59_44_+1100_q7vlz+m6A.SGxWbA
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi John,

Today's linux-next merge of the wireless tree got a conflict in
drivers/net/wireless/iwlwifi/iwl-4965.c between commit
be6b38bcb175613f239e0b302607db346472c6b6 ("iwlwifi: counting number of
tfds can be free for 4965") from the wireless-current tree and commit
74bcdb33e99f49ef5202dd2f8109945b4570edc2 ("iwlwifi: move agn only tx
functions from iwlcore to iwlagn") from the wireless tree.

I fixed it up (see below) and can carry the fix for a while.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/net/wireless/iwlwifi/iwl-4965.c
index 3297fc7,1808c97..0000000
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@@ -2046,15 -2047,17 +2047,15 @@@ static void iwl4965_rx_reply_tx(struct=20
  				   le32_to_cpu(tx_resp->rate_n_flags),
  				   tx_resp->failure_frame);
 =20
- 		freed =3D iwl_tx_queue_reclaim(priv, txq_id, index);
+ 		freed =3D iwlagn_tx_queue_reclaim(priv, txq_id, index);
 -		if (qc && likely(sta_id !=3D IWL_INVALID_STATION))
 -			priv->stations[sta_id].tid[tid].tfds_in_queue -=3D freed;
 +		iwl_free_tfds_in_queue(priv, sta_id, tid, freed);
 =20
  		if (priv->mac80211_registered &&
  		    (iwl_queue_space(&txq->q) > txq->q.low_mark))
  			iwl_wake_queue(priv, txq_id);
  	}
 =20
- 	iwl_txq_check_empty(priv, sta_id, tid, txq_id);
 -	if (qc && likely(sta_id !=3D IWL_INVALID_STATION))
 -		iwlagn_txq_check_empty(priv, sta_id, tid, txq_id);
++	iwlagn_txq_check_empty(priv, sta_id, tid, txq_id);
 =20
  	if (iwl_check_bits(status, TX_ABORT_REQUIRED_MSK))
  		IWL_ERR(priv, "TODO:  Implement Tx ABORT REQUIRED!!!\n");

--Signature=_Thu__1_Apr_2010_12_59_44_+1100_q7vlz+m6A.SGxWbA
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkuz/hAACgkQjjKRsyhoI8zkHgCfWFXTe2M3wqP7RXu0M7wj7jsY
9H8An2FeqmaXXGccU9BLGExDjwfghmoa
=NHeM
-----END PGP SIGNATURE-----

--Signature=_Thu__1_Apr_2010_12_59_44_+1100_q7vlz+m6A.SGxWbA--
