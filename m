Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753602Ab0K0VOO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Nov 2010 16:14:14 -0500
Received: from relay.cooperix.net ([67.23.6.41]:41071 "EHLO relay.sandelman.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753380Ab0K0VON (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Nov 2010 16:14:13 -0500
From: Michael Richardson <mcr@sandelman.ca>
To: Greg KH <gregkh@suse.de>
cc: linux-kernel@vger.kernel.org, bart@jukie.net
Subject: Re: odd behavior from /sys/block (sysfs) 
In-Reply-To: <20101127185829.GA19708@suse.de> 
References: <5108.1290796566@marajade.sandelman.ca>  <20101127185829.GA19708@suse.de> 
X-Mailer: MH-E 8.1; nmh 1.1; XEmacs 21.4 (patch 21)
Date: Sat, 27 Nov 2010 16:14:11 -0500
Message-ID: <4605.1290892451@marajade.sandelman.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1


>>>>> "Greg" == Greg KH <gregkh@suse.de> writes:
    >> {please CC me}
    >> 
    >> I was capturing data from my laptop's /sys file system as test input
    >> for some code that needs to grovel through /sys a bit.  I found it weird
    >> that tar got different answers than ls!  See below (at end) for original
    >> observation.
    >> 
    >> It seems that this is because lstat64() on sysfs returns st_size=0 for
    >> the link, and tar does not know how to deal with this, while ls does.
    >> I don't know if it is tar that is wrong, or sysfs.
    >> lstat64(3) suggests that it is sysfs that is at fault, that it should
    >> set st_size.  The behaviour of ls, suggests that perhaps other systems
    >> have worked around st_size=0 for symlinks.  (I'm on 2.6.32-bpo.5
    >> from debian) 

    Greg> So, what do you think should be changed here?

Iif st_size=0 is not a valid return from readlink(2), then I think sysfs
should be fixed.    I will cook a patch.

While tar might not useful (I was successful at using cp -r, btw),
having working file operations makes sense. 

    Greg> I wouldn't ever recommend using tar on sysfs as it doesn't make any
    Greg> sense (sysfs is a virtual file system, like /proc/ and I think
    Greg> that tar doesn't like /proc either, right?)

Are there things on /sys for which a read is not idempotent?

On /proc, there are files which never terminate, because the process is
introspecting itself.  Taking a snapshot of /sys is kinda a useful thing
if you collecting diagnostics, I think. 

- -- 
]       He who is tired of Weird Al is tired of life!           |  firewalls  [
]   Michael Richardson, Sandelman Software Works, Ottawa, ON    |net architect[
] mcr@sandelman.ottawa.on.ca http://www.sandelman.ottawa.on.ca/ |device driver[
   Kyoto Plus: watch the video <http://www.youtube.com/watch?v=kzx1ycLXQSE>
	               then sign the petition. 


-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Finger me for keys

iQEVAwUBTPF0nYCLcPvd0N1lAQI83Af+M5duLS+DHptiGhvE5IhVAtUdUcUrIW69
n8ipLp/c0cv8cU5pFiZrb4cv/dUDcite97CYw85WkWe28wIOjgdRgB7DxclleNLm
dgA5AzY7MSIsFL81k5lDWTiyTGx7v76DIWfMS5iMvF9lIOkX/2wG9AfQLb08AYU2
ePywvGgQtZYrXrvgPFWhFLOpmibc5v/9QqY+GhJZa56qFzsYX4OjWix7HyyYgIg+
AG1YBFowoWsFS/sw2YEaXbWivgbOfNkpo6duT03APDLoOfk+Lxb6BZWYUYY3yh0Y
4HfJiIA6XnESEqV0hGey9w6kzVoS6rn5gZmlOL81xAa3dg1JBxyd8Q==
=q414
-----END PGP SIGNATURE-----
