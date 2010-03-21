Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753958Ab0CUVFJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Mar 2010 17:05:09 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:58431 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753869Ab0CUVEn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Mar 2010 17:04:43 -0400
X-Sasl-enc: owfkU30ajAKv7qVACewuly5YLiI6+pxlGvIctd3Few5f 1269205482
Message-ID: <4BA689EA.4050102@imap.cc>
Date: Sun, 21 Mar 2010 22:04:42 +0100
From: Tilman Schmidt <tilman@imap.cc>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; de; rv:1.9.1.8) Gecko/20100228 SUSE/3.0.3-1.1.1 Thunderbird/3.0.3
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: CONFIG_PROVE_RCU breaks proprietary modules (rcu_lock_map)
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

I know there's not much sympathy for troubles with proprietary modules
here, but the following might save some trouble to kernel developers as
well as users forced to resort to proprietary drivers:

Setting the kernel configuration option PROVE_RCU creates a reference to
the GPL-exported global variable rcu_lock_map even in modules that do
not use RCU. In the case of non-GPL modules, this leads to a build
failure because of the license incompatibility.
(I did not find out where that reference comes from.)

So if building a proprietary module fails with the message:

FATAL: modpost: GPL-incompatible module <module> uses GPL-only symbol
'rcu_lock_map'

try rebuilding your kernel with the PROVE_RCU option disabled.

Hope it helps someone.

Tilman
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org/

iEYEARECAAYFAkumieoACgkQQ3+did9BuFtC4gCggSE8DNVc8k9tasN7VOoQMR4G
IKUAnj+SkzZjmJQPmUScvaY4zP8hR19o
=2rDg
-----END PGP SIGNATURE-----
