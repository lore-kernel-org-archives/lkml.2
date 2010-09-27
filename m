Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757201Ab0I0XkD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 19:40:03 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:37214 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752196Ab0I0XkB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 19:40:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=QS3yYfKB/znx6hJuL/h3n7mPOFxaTlfqczXQKgTy2fbbDOtn6IHis0QNPAe2HRuLPJ
         19DSdmdbXbFfl350e1Ns2rxIlCeuP5vksS5deIhFtFJQ+nL/1YboecN6CqJN58kfFfVJ
         2qRKNOdIXzLSsdxDgkSdaTRc0p4h/OllFKHdE=
Date: Mon, 27 Sep 2010 19:39:56 -0400
From: tmhikaru@gmail.com
To: Florian Mickler <florian@mickler.org>, Greg KH <gregkh@suse.de>,
        linux-kernel@vger.kernel.org
Subject: Re: Linux 2.6.35.6
Message-ID: <20100927233956.GA15705@roll>
References: <20100927003608.GA20395@kroah.com> <20100927163208.GA4892@roll> <20100927215135.3d11d587@schatten.dmk.lab>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="huq684BweRXVnRxX"
Content-Disposition: inline
In-Reply-To: <20100927215135.3d11d587@schatten.dmk.lab>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--huq684BweRXVnRxX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 27, 2010 at 09:51:35PM +0200, Florian Mickler wrote:
> I can't comment on the bouncing part, but increased load average is
> partly bisected down in Bug 16525 (unexpected high load since 2.6.35
> Bug 16525)[1]. Maybe you are seeing something similiar?=20

If you're referring to

https://bugzilla.kernel.org/show_bug.cgi?id=3D16525

then I have to admit that's very interesting; in fact, I tested my machine
without X running, and the problem I'm having goes away entirely - loadavg
quickly settles to 0.00 - and even with *only* a mrxvt terminal running,
that is to say NO window manager, just mrxvt running, X on 2.6.35.3 and
later has the wildly bouncy load averages.

Here's a graphical example of just how wacky this is:

http://yfrog.com/6lloadbp

In this image, the dip down to less than 0.5 after the 18'th is due to me
experimenting using the slackware distribution kernel (2.6.33.4) after I
finally noticed something was amiss. The sharp rise afterwards is due to me
first, building 2.6.35.5, and then afterwards, using it. To be perfectly
clear, I've previously used 2.6.34.2 and did not experience the problem
there either, nor is it in 2.6.33.4.

The majority of time during the last month the machine has sat idle, with
nothing to do except idle with the screen turned off. Besides building
kernels, the most difficult task I've asked of it has been websurfing. This
is not exactly a difficult job for this machine, and hardly would normally
push the load average up that high for that long.

Greg, I noticed that in the ChangeLogs for 2.6.35.x there were some patches
for the intel driver which seem to be to my untrained eye an attempt to fix
Linus' problem talked about in that bug report; The patch that is referenced
in the bug report contains some things at least that were not applied to the
tree; since I have no idea what I'm looking at, could you verify for me if
I'm barking up the right tree here? If I am, I'll try building a clean
2.6.35 kernel with that patch applied and see if my problem disappears.

Anyway, I am now going to start going backwards through 2.6.35.x until I
discover which version(s) caused my particular issue. Since 2.6.35.3 and
later have had the problem, and 2.6.35.2 will not compile for me, I'm going
to first compile and test 2.6.35.1.

This will probably take some time as the bouncy load averages are
consistently inconsistent and tend to, much like a watched kettle, not show
up when I expect them to, then do so immediately when I turn my back. :)

Thanks for the tip,
Tim McGrath

--huq684BweRXVnRxX
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEVAwUBTKErTJEncCrqzVruAQIpLAf6AoQfPMcfQJhKKDpXQ9GRGagmFV3NljdG
XI8McRfWRMnxwuxFXvoHXzUvz2XCJDh9nGFDaLR1bOzJooXCqSblBKHysyOUAwBn
7ANMg6pbKtNxBli8Em8YEGxb/2WbXGXMAM0XiTdlIwkSNtO4+F4dypxrmHLml3W1
UIfO/WDdhXe3XKhr2JsljjC/UYA3bGxhjkmmory2AtYWytiZbn3smOA9OcfzJf/9
+QrtZlGvZjN6jNsk4ODXG1wWNMpIuTZL2A70YZ6mOWVYsfj1rZllgJ9i//X4s/XB
x01eNVPtfdefRdiqHAutBn4M/iQ0DxDn0ec/UivP1KZNfq0VLFQsuw==
=8zR4
-----END PGP SIGNATURE-----

--huq684BweRXVnRxX--
