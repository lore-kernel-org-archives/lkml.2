Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754133Ab1E2Nwy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 May 2011 09:52:54 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:37315 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753345Ab1E2Nwx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 May 2011 09:52:53 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        viro@zeniv.linux.org.uk, Andi Kleen <ak@linux.intel.com>,
        chris.mason@oracle.com, josef@redhat.com, agruen@linbit.com,
        "Serge E. Hallyn" <serue@us.ibm.com>
Subject: Re: [PATCH 1/4] Cache xattr security drop check for write
In-Reply-To: Your message of "Fri, 27 May 2011 15:54:02 PDT."
             <1306536845-24162-1-git-send-email-andi@firstfloor.org>
From: Valdis.Kletnieks@vt.edu
References: <1306536845-24162-1-git-send-email-andi@firstfloor.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1306677144_27223P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Sun, 29 May 2011 09:52:24 -0400
Message-ID: <95980.1306677144@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Status: score=10/50, host=steiner.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020201.4DE24F9D.000A,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1306677144_27223P
Content-Type: text/plain; charset=us-ascii

On Fri, 27 May 2011 15:54:02 PDT, Andi Kleen said:

> @@ -2578,5 +2580,10 @@ int __init get_filesystem_list(char *buf);
>  #define OPEN_FMODE(flag) ((__force fmode_t)(((flag + 1) & O_ACCMODE) | \
>  					    (flag & __FMODE_NONOTIFY)))
>  
> +static inline int is_sgid(mode_t mode)
> +{
> +	return (mode & S_ISUID) || ((mode & S_ISGID) && (mode & S_IXGRP));
> +}
> +

There has *got* to be a better name for this function.

And having said that, I'm not convinced it's the *right* check - on an SELinux
system, pretty much *all* the files have a security xattr attached to them, and
very few are actually setuid/setgid. So 98% of the time, or more, this will DTWT.


--==_Exmh_1306677144_27223P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFN4k+YcC3lWbTT17ARAnAAAJ96L0awCke242a4c0pD81+HmjDgwQCfWtU2
/iF3VdVec0UcWfhM7/VEMNM=
=GAjY
-----END PGP SIGNATURE-----

--==_Exmh_1306677144_27223P--

