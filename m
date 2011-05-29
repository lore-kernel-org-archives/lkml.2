Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755001Ab1E2Rso (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 May 2011 13:48:44 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:48125 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752761Ab1E2Rsm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 May 2011 13:48:42 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Andi Kleen <ak@linux.intel.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk,
        chris.mason@oracle.com, josef@redhat.com, agruen@linbit.com,
        "Serge E. Hallyn" <serue@us.ibm.com>
Subject: Re: [PATCH 1/4] Cache xattr security drop check for write
In-Reply-To: Your message of "Sun, 29 May 2011 07:24:32 PDT."
             <20110529142432.GA7103@alboin.amr.corp.intel.com>
From: Valdis.Kletnieks@vt.edu
References: <1306536845-24162-1-git-send-email-andi@firstfloor.org> <95980.1306677144@turing-police.cc.vt.edu>
            <20110529142432.GA7103@alboin.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1306691306_27223P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Sun, 29 May 2011 13:48:26 -0400
Message-ID: <105043.1306691306@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Status: score=10/50, host=vivi.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020209.4DE286EE.0158,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1306691306_27223P
Content-Type: text/plain; charset="us-ascii"
Content-Id: <105036.1306691306.1@turing-police.cc.vt.edu>

On Sun, 29 May 2011 07:24:32 PDT, Andi Kleen said:

> These are not for selinux xattrs, but capability xattrs.

+#define S_NOSEC		4096	/* no suid or xattr security attributes */

Sorry for reading that wrong, since selinux stores stuff under security.* xattr
as well.

+	int issec = !strncmp(name, XATTR_SECURITY_PREFIX,
+				   XATTR_SECURITY_PREFIX_LEN);
 
is going to match *any* security.* attribute, including SELinux ones stored under
security.selinux.  If you wanted to be capability-specific, maybe youw anted these
two:

#define XATTR_CAPS_SUFFIX "capability"
#define XATTR_NAME_CAPS XATTR_SECURITY_PREFIX XATTR_CAPS_SUFFIX


--==_Exmh_1306691306_27223P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFN4obqcC3lWbTT17ARAvrXAKD6HBLfY7GIsOgf9IrPG4uM6zxwuQCffwWT
H7DsAPdAwEEPbC220ISEtY4=
=2KHl
-----END PGP SIGNATURE-----

--==_Exmh_1306691306_27223P--

