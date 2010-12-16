Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755063Ab0LPLFh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 06:05:37 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:58840 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754152Ab0LPLFe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 06:05:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=gRJC2QG6xcQUV1TgtjZGm1V+IohyZeykoucHjlA9K7CjZ5pQ/tjUmDcHAG/lCbfOsC
         wyheUYpUzp98383FN/ekRLPFVEpCazoeC9CgptIJ8oX0yjmjSLJ4YW+VDMx/3Yv+tddP
         L3CVgmXikROVUueHvYrhI8ZJ+Qxpyr2Q/EujQ=
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <AANLkTinbhb-_v+8tJBPeoLcDo0mFzwo2EZAy3bnvErFT@mail.gmail.com>
References: <AANLkTinbhb-_v+8tJBPeoLcDo0mFzwo2EZAy3bnvErFT@mail.gmail.com>
Date: Thu, 16 Dec 2010 12:05:32 +0100
Message-ID: <AANLkTi=t0VqSiZ=k9rBxPBVnHxy6v3JvTwW-n6ngM1f0@mail.gmail.com>
Subject: Re: linux-next: Tree for December 16 (broken iwlwifi)
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
        John Linville <linville@tuxdriver.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        wireless <linux-wireless@vger.kernel.org>,
        Johannes Berg <johannes.berg@intel.com>,
        Wey-Yi Guy <wey-yi.w.guy@intel.com>,
        Randy Dunlap <randy.dunlap@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 16, 2010 at 11:54 AM, Sedat Dilek
<sedat.dilek@googlemail.com> wrote:
> Hi,
>
> Just FYI (didn't look at the code right now, sorry for German output):
>
> [ build.log ]
> ...
> /home/sd/src/linux-2.6/linux-2.6.37-rc5/debian/build/source_i386_none/drivers/net/wireless/iwlwifi/iwl-agn-rs.c:
> In function ‘iwl_rs_rate_init’:
> /home/sd/src/linux-2.6/linux-2.6.37-rc5/debian/build/source_i386_none/drivers/net/wireless/iwlwifi/iwl-agn-rs.c:2876:8:
> error: ‘struct iwl_lq_sta’ has no member named ‘dbg_fixed_rate’
> make[8]: *** [drivers/net/wireless/iwlwifi/iwl-agn-rs.o] Fehler 1
> make[7]: *** [drivers/net/wireless/iwlwifi] Fehler 2
> make[6]: *** [drivers/net/wireless] Fehler 2
> make[6]: *** Warte auf noch nicht beendete Prozesse...
> ...
>
> Regards,
> - Sedat -
>

Looks like dbg_fixed_rate is only set when CONFIG_MAC80211_DEBUGFS is set:

[ drivers/net/wireless/iwlwifi/iwl-agn-rs.h ]
...
#ifdef CONFIG_MAC80211_DEBUGFS
        struct dentry *rs_sta_dbgfs_scale_table_file;
        struct dentry *rs_sta_dbgfs_stats_table_file;
        struct dentry *rs_sta_dbgfs_rate_scale_data_file;
        struct dentry *rs_sta_dbgfs_tx_agg_tid_en_file;
        u32 dbg_fixed_rate;
#endif
...

So I have no CONFIG_MAC80211_DEBUGFS... :-).
Can someone fix that, please?

- Sedat -
