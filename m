Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754481Ab1GEThV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 15:37:21 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:65238 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753909Ab1GEThT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 15:37:19 -0400
Date: Tue, 5 Jul 2011 15:37:15 -0400
From: Eric B Munson <emunson@mgebm.net>
To: Glauber Costa <glommer@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rik van Riel <riel@redhat.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Peter Zijlstra <peterz@infradead.org>, Avi Kivity <avi@redhat.com>,
        Anthony Liguori <aliguori@us.ibm.com>
Subject: Re: [PATCH v5 8/9] KVM-GST: adjust scheduler cpu power
Message-ID: <20110705193715.GH3436@mgebm.net>
References: <1309793548-16714-1-git-send-email-glommer@redhat.com>
 <1309793548-16714-9-git-send-email-glommer@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="X1xGqyAVbSpAWs5A"
Content-Disposition: inline
In-Reply-To: <1309793548-16714-9-git-send-email-glommer@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--X1xGqyAVbSpAWs5A
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, 04 Jul 2011, Glauber Costa wrote:

> This patch makes update_rq_clock() aware of steal time.
> The mechanism of operation is not different from irq_time,
> and follows the same principles. This lives in a CONFIG
> option itself, and can be compiled out independently of
> the rest of steal time reporting. The effect of disabling it
> is that the scheduler will still report steal time (that cannot be
> disabled), but won't use this information for cpu power adjustments.
>=20
> Everytime update_rq_clock_task() is invoked, we query information
> about how much time was stolen since last call, and feed it into
> sched_rt_avg_update().
>=20
> Although steal time reporting in account_process_tick() keeps
> track of the last time we read the steal clock, in prev_steal_time,
> this patch do it independently using another field,
> prev_steal_time_rq. This is because otherwise, information about time
> accounted in update_process_tick() would never reach us in update_rq_cloc=
k().
>=20
> Signed-off-by: Glauber Costa <glommer@redhat.com>
> CC: Rik van Riel <riel@redhat.com>
> CC: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> CC: Peter Zijlstra <peterz@infradead.org>
> CC: Avi Kivity <avi@redhat.com>
> CC: Anthony Liguori <aliguori@us.ibm.com>
> CC: Eric B Munson <emunson@mgebm.net>

Tested-by: Eric B Munson <emunson@mgebm.net>

--X1xGqyAVbSpAWs5A
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOE2frAAoJEH65iIruGRnNfwoIAJnbEKqoxNAh9vMDw6DiceQY
xzkClikp4MBpEVb4e92yx9m7DtdXIWeFhJEtoZxWeDqRXs8fr/xlC0WgtgC2COW+
9Rg5xbgQPwjbKp6Tfjq5hZNYuvNsUw80eXCnkT1Jaid/ATuDlTBDynAgCwuecaYv
yxoFB1950TL6Y9w/ExK9PD7x7LFr7cIXh1ZUs5J8BR7ea0BmVgWWhB42yGm+SiCL
re6U16Tp29fsQMjWRJtS+ZUKqYFxmb4I0Ax6q+he1FZOAxX9YEtSK/yPouEDFcoM
VhJN2O8f87oJe1Bxk69EJ3oZ1rlemUwxXTrzckbLdv0HpnWGOwLYx6+gRzENfJM=
=viwk
-----END PGP SIGNATURE-----

--X1xGqyAVbSpAWs5A--
