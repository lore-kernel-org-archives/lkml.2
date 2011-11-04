Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755279Ab1KDLwK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 07:52:10 -0400
Received: from mail1.SerNet.de ([193.175.80.2]:55671 "EHLO mail.SerNet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754029Ab1KDLwI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 07:52:08 -0400
X-Greylist: delayed 2114 seconds by postgrey-1.27 at vger.kernel.org; Fri, 04 Nov 2011 07:52:07 EDT
Date: Fri, 4 Nov 2011 12:16:36 +0100
From: =?iso-8859-1?Q?Bj=F6rn?= JACKE <bj@SerNet.DE>
To: Anton Altaparmakov <aia21@cam.ac.uk>
Cc: Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, LKML <linux-kernel@vger.kernel.org>,
        Unix Support <unix-support@ucs.cam.ac.uk>,
        linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: CIFS: Rename bug on servers not supporting inode numbers
Mail-Followup-To: Anton Altaparmakov <aia21@cam.ac.uk>,
	Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	LKML <linux-kernel@vger.kernel.org>,
	Unix Support <unix-support@ucs.cam.ac.uk>,
	linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com
References: <9A609E6D-DF91-4AF9-855A-6D28E9B95D15@cam.ac.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <9A609E6D-DF91-4AF9-855A-6D28E9B95D15@cam.ac.uk>
X-Q: Die Schriftsteller =?iso-8859-1?Q?k=F6nnen?=
 =?iso-8859-1?Q?_nicht_so_schnell_schreiben=2C_wie_die_Regierungen_Krieg?=
 =?iso-8859-1?Q?e?= machen; denn das Schreiben verlangt Denkarbeit. - Brecht
Message-Id: <E1RMHlS-00HYp9-Hk@intern.SerNet.DE>
Organization: SerNet GmbH, Goettingen, Germany
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-11-03 at 15:20 +0000 Anton Altaparmakov sent off:
> Hi,
> 
> Our CIFS server problems seem to have no end…  The Novell CIFS server does not support server inode numbers (when I try the mount option I get the message it is being turned off as server does not support it) and thus each inode gets a different number each time it is accessed and it gets a different number again for each readdir call.
> 
> The fun happens with rename() when the rename source and target only differ in case, e.g.
> 
> 	touch foo
> 	mv foo Foo

somehow related seems https://bugzilla.kernel.org/show_bug.cgi?id=39512
(as long as kernel bugzilla is dead, see
http://www.linux.sgi.com/archives/xfs-masters/2011-07/msg00022.html )

Case insensitive filesystems seem to be a problem in general on Linux. Not sure
how far kernel and/or glibc are involved in the problem. As a workaround for
the mess you need to do a temporary rename to a different name (not just a case
equivalent name).

Björn
-- 
SerNet GmbH, Bahnhofsallee 1b, 37081 Göttingen
phone: +49-551-370000-0, fax: +49-551-370000-9
AG Göttingen, HRB 2816, GF: Dr. Johannes Loxen
