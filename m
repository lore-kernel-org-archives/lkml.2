Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755351Ab0LIAPp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 19:15:45 -0500
Received: from mail-iw0-f172.google.com ([209.85.214.172]:43700 "EHLO
	mail-iw0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755228Ab0LIAPm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 19:15:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:cc:content-type;
        b=VxtRJOh3MFrwkb1EN8lKx21pBKe/MjzMfYYd+XdJGhz88QWbMYAf/AOuphv3tTJcJM
         nrrcM1hBYoUNzHrzKpUrElhBDgCNhZAF3dvljV9OtMNHr2MiJwdWIOila/+XYzChBEf8
         U41HECt8UsNXel0q23BgRpJHO2mCdff8E+AVE=
MIME-Version: 1.0
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Wed, 8 Dec 2010 16:15:11 -0800
Message-ID: <AANLkTim5HQGNL-vSapeQw_-dJue89pYz7zc8eiShma8j@mail.gmail.com>
Subject: compat-wireless-2.6.37-rc5 released
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: linux-kernel@vger.kernel.org,
        linux-bluetooth <linux-bluetooth@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We're closing in on the 2.6.37 release, now at rc5, so I'll start
making two releases, a vanilla release and one which has more stuff.
For now I'll just suck in all pending stable patches (all patches
marked with Cc: stable@kernel.org on linux-next.git, not only
Atheros', everyone's). This is:

pending-stable/0001-cfg80211-pass-the-reg-hint-initiator-to-helpers.patch
pending-stable/0002-cfg80211-fix-allowing-country-IEs-for-WIPHY_FLAG_STR.patch
pending-stable/0003-cfg80211-fix-disabling-channels-based-on-hints.patch
pending-stable/0004-ath9k_hw-fix-potential-spurious-tx-error-bit-interpr.patch
pending-stable/0005-ath9k-simplify-hw-reset-locking.patch
pending-stable/0006-ath9k-move-the-PCU-lock-to-the-sc-structure.patch
pending-stable/0007-ath9k-content-DMA-start-stop-through-the-PCU-lock.patch
pending-stable/0008-ath9k_hw-Fix-XPABIAS-level-configuration-for-AR9003.patch
pending-stable/0009-ath9k-Fix-bug-in-delimiter-padding-computation.patch
pending-stable/0010-ath9k-Disable-SWBA-interrupt-on-remove_interface.patch
pending-stable/0011-mac80211-Fix-STA-disconnect-due-to-MIC-failure.patch
pending-stable/0012-ath9k-Fix-STA-disconnect-issue-due-to-received-MIC-f.patch
pending-stable/0013-ath9k-Fix-bug-in-reading-input-gpio-state-for-ar9003.patch
pending-stable/0014-ath9k_hw-fix-endian-issues-with-CTLs-on-AR9003.patch

You can find the vanilla [1] and extra pending-stable [2] releass on
the stable download page [3] along with the respective ChangeLog of
all:

  * The kernel components
  * compat-wireless
  * compat

In later releases we will have to consider if we want to cherry pick
anything extra or leave them as is. These few patches seem tempting to
suck in:

01-ath9k-OTP.patch
03-ath9k-no-aggr-VO.patch
04-mac80211-no-aggr-VO.patch
05-ath9k-Reintroduce-modparam-to-enable-btcoex.patch
06-ath9k_hw-fix-A-MPDU-key-search-issues-on-AR9003.patch

Particularly it is now known AR9003 devices will only ship with OTP
so.. it seems to make sense to actually disable AR9003 on 36 and even
37 and only have it available with the OTP patch and above EEPROM
fixes. I'm inclined to just disregard all these and just let us get
AR9003 from 2.6.38.... but we already have users of AR9003 coming up
so this can't wait in practice now. This now goes compile-tested and
fixed for 2.6.31.

[1] http://www.orbit-lab.org/kernel/compat-wireless-2.6-stable/v2.6.37/compat-wireless-2.6.37-rc5-2.tar.bz2
[2] http://www.orbit-lab.org/kernel/compat-wireless-2.6-stable/v2.6.37/compat-wireless-2.6.37-rc5-2-s.tar.bz2
[3] http://wireless.kernel.org/en/users/Download/stable
[4] http://www.orbit-lab.org/kernel/compat-wireless-2.6-stable/v2.6.37/ChangeLog-2.6.37-wireless

  Luis
