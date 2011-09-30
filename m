Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754174Ab1I3Xux (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 19:50:53 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38361 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753984Ab1I3Xuq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 19:50:46 -0400
Message-ID: <4E8655CD.90107@zytor.com>
Date: Fri, 30 Sep 2011 16:50:37 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: kernel.org status: establishing a PGP web of trust
X-Enigmail-Version: 1.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hi all,

Since the kernel.org status announcement last week a number of you
have contacted me about re-establishing credentials.  In order to
establish a proper PGP web of trust we need keys that are cross-signed
by other developers.  As such, we ask that you follow the following
steps:

1. Make sure your systems are uncompromised.  We will address specific
   recommended steps for that in a separate email.

2. Create a new PGP/GPG key, and also generate a key revocation
   certificate (but don't import it anywhere -- save it for the
   future) for your new key.  In the near future we are considering
   setting up an escrow service for key revocation certificates.

   I recommend using a 4096-bit RSA key.  Given how fast computers are
   these days, there is no reason to use a shorter key.  DSA keys
   should be considered obsolete; substantial weaknesses have been
   found in DSA.

   $ gpg --gen-key
   $ gpg -u <key ID> -o <key ID>.revoke --gen-revoke

3. If you are reasonably certain that your old key has never been
   jeopardized, sign the new key with the old key.

   $ gpg -u <your old key ID> --sign-key <your new key ID>

   If you are *not* sure about your old keys, please revoke them if
   you haven't already done so (create a revocation certificate and
   import it into your keyring, then push the key to the key servers.)

   $ gpg -u <your old key ID> -o <your old key ID>.revoke --gen-revoke
   $ gpg --import <your old key ID>.revoke
   $ gpg --keyserver pgp.mit.edu --send-key <your old key ID>

4. Upload the signed keys to the keyserver system (I usually use
   pgp.mit.edu, but most of the keyservers sync with each other with
   roughly a 24-hour delay.)  By publishing the keys we make them
   available not only to kernel.org but for other uses, like signing
   email, and you can verify yourself by looking at http://pgp.mit.edu/
   if there is someone out there who has published a key with your name
   on it.  Furthermore, it allows us to tap other webs of trust already
   established.

   $ gpg --keyserver pgp.mit.edu --send-key <your key ID>

5. Get as many other kernel developers that you have physical access to
   to sign your key after verifying the fingerprint.  Verifying keys
   over the phone is OK if and only if you know them *extremely* well;
   think "would I be willing to testify in court that the person I
   talked to was X"?

   If you work in an office with multiple other Linux developers, it
   would be a very good thing to organize a local key signing.  We will
   do a key signing at Kernel Summit for the core kernel developers.

   A web site with recommendations for running a key signing:


http://www.cryptnet.net/fdp/crypto/keysigning_party/en/keysigning_party.html

   $ gpg --fingerprint <key ID>
   $ gpg --keyserver pgp.mit.edu --recv-key <their key ID>
   $ gpg -u <your key ID> --sign-key <their key ID>
   $ gpg --keyserver pgp.mit.edu --send-key <their key ID>
   $ gpg --keyserver pgp.mit.edu --recv-key <your key ID>

6. Please send me the key identifier and fingerprint to
   <keys@zytor.com>.  This is a temporary address until the kernel.org
   MX is ready to put back online; eventually we will probably have a
   web form interface for this.

	-hpa

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQIcBAEBAgAGBQJOhlXFAAoJEL2gYIVJO6zkc7MP/2Qb6iOGCMEd3ncV8N9Znqsf
nPYnjS7Eo8EafbC5A/Pe5UaqzVw3UrWAewTENUaNndXuTDRYhvt2SeQEbASpCTfG
Wr0WPzcrrnIOhJDk9WyLUIE+wR52Alq/EYmiRBDBNJmNqwo7SgXVpyDqMvLeH9IH
LCey68XfQ2WrD25p3a3zmi5woGuluQsUVYNJCB0yC1RpESJDO6GNx+tUWWR6kRk1
GmaUs0qrx9nHrycQZIq1pga3v/uxSvxr7pYAvLMLvl0pCFE+GbQ+wCMqpddOTA0/
0d5QVRqL1neCMGYUm+9Ff3AzzyaqTKHPOm6grnUp+M73+3FJIMzr3BOEIJnusJA5
vDPjHl8j3+LJXeTNNp3V/pmM89uc9vWjdyRoMyeufN2simC07csxh8E8s35hz3gj
z6tdch9ygHJt1rS3XuJva9p5kNm0ptMtbF1wWzJCci8Lo7iiMoj0GECyeIzvEbic
qG6sUfgIORGe3OH8MPCdmn2BY1y0Rz6rD05s1nZOBxOoYihrtDrnNC5MJl4+lvTW
7fzTFVzbjQO7Ybu/PqLeAJ4ieTFflbp4j7dI9dTKxHfTKQ+NT1YgiRpS7gcZeDhS
YmVKMmN5QpxFqMYhr9gc2S/6iYwRTP1juWMf0bxP9xiY/SaBhW8XrpyxE85svc+o
9j39P8QGHPb35HQ2HPgn
=PdWd
-----END PGP SIGNATURE-----
