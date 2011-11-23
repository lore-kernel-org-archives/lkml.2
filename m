Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759727Ab1KWCCL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 21:02:11 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:52419 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754288Ab1KWCCJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 21:02:09 -0500
Date: Wed, 23 Nov 2011 13:01:48 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Deng-Cheng Zhu <dczhu@mips.com>, Ralf Baechle <ralf@linux-mips.org>
Subject: linux-next: manual merge of the tip tree with the mips tree
Message-Id: <20111123130148.2a437aabdf6120e7e9b6928c@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__23_Nov_2011_13_01_48_+1100_AbgM4kL//fQY7cFK"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__23_Nov_2011_13_01_48_+1100_AbgM4kL//fQY7cFK
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the tip tree got a conflict in
arch/mips/kernel/perf_event_mipsxx.c between commit f40c522a4216
("MIPS/Perf-events: Remove erroneous check on active_events") and
c481e48d9478 ("MIPS/Perf-events: Remove pmu and event state checking in
validate_event()") from the mips tree and commit aa2bc1ade590 ("perf:
Don't use -ENOSPC for out of PMU resources") from the tip tree.

Just context changes (and one hunk was removed).  I fixed it up (see
below) and can carry the fix as necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/mips/kernel/perf_event_mipsxx.c
index bda4bc9,315fc0b..0000000
--- a/arch/mips/kernel/perf_event_mipsxx.c
+++ b/arch/mips/kernel/perf_event_mipsxx.c
@@@ -710,16 -731,16 +710,16 @@@ static int validate_group(struct perf_e
 =20
  	memset(&fake_cpuc, 0, sizeof(fake_cpuc));
 =20
 -	if (!validate_event(&fake_cpuc, leader))
 +	if (mipsxx_pmu_alloc_counter(&fake_cpuc, &leader->hw) < 0)
- 		return -ENOSPC;
+ 		return -EINVAL;
 =20
  	list_for_each_entry(sibling, &leader->sibling_list, group_entry) {
 -		if (!validate_event(&fake_cpuc, sibling))
 +		if (mipsxx_pmu_alloc_counter(&fake_cpuc, &sibling->hw) < 0)
- 			return -ENOSPC;
+ 			return -EINVAL;
  	}
 =20
 -	if (!validate_event(&fake_cpuc, event))
 +	if (mipsxx_pmu_alloc_counter(&fake_cpuc, &event->hw) < 0)
- 		return -ENOSPC;
+ 		return -EINVAL;
 =20
  	return 0;
  }

--Signature=_Wed__23_Nov_2011_13_01_48_+1100_AbgM4kL//fQY7cFK
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOzFQMAAoJEECxmPOUX5FEQxIP/RH2SpAcwNdrJmqihjptyRtD
56CYG/SBIQj/lTERcRb2TsYXBR+uf+7ftKhIALtpyWaZIYwzrRs3Fook6gE8HGCP
BrO8Pn07NOM7JMJ52dB8MjJFFV/vh0MHYW3WnEZ85G3qVmSM5z+lPl5hewBzWidZ
iMxcH+J6xV3ly80eVI/SmDa3IN1UcBpi9aX6C8uy1Rjk9G2T/WfDheNQkP95U4Iu
zua0l+TKU5OkBo95I27U8tkRJGcZ0QGwW7X/79poTvhwEx1CsDGsoDZlhBqML4Qh
mtwQrm8C9Jd2awkuTtyFJoterQAh0kNNTGQtIxjmTq908cA594Ia7CQbxMXD86tw
qRIc4veeY2OlO3fPS6LA9LSt3tOnu+9dfkfSosY5rQUEDHEV5xLVt29bUJm4DtM1
WJXo3WbGMXcZMs5YZPh5WwEF97hba8/BuO23QWeCKMEY0cFBCq+mrrYc/IupCgmX
eMc6pjkrYFrlNfVt+fe2yZCA2r2GCso88kDLBn7HKOJWmPwhuK98jQIiXg8XrM1b
oEDour2wgpvKc81Jaf71+H7XQ04cRfj+lO4TgQEr+BeOsz6624IbhKn5wkwrXJmW
CbAY6knLLqxJO2wPRi7qcfJFLa4Ix98mLlqoGTY5D+PApw0oyFKC4zzcmCzGxmHQ
gsx4fSYEbgMn/O5ZPKTR
=joMK
-----END PGP SIGNATURE-----

--Signature=_Wed__23_Nov_2011_13_01_48_+1100_AbgM4kL//fQY7cFK--
