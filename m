Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752390Ab0C0HoY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Mar 2010 03:44:24 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:37920
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752059Ab0C0HoX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Mar 2010 03:44:23 -0400
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: David Miller <davem@davemloft.net>
Subject: Re: Commit 085219f79cad broke Sparc-32 back in 2.6.28.
Date: Sat, 27 Mar 2010 02:44:16 -0500
User-Agent: KMail/1.11.2 (Linux/2.6.28-18-generic; KDE/4.2.2; x86_64; ; )
Cc: blauwirbel@gmail.com, linux-kernel@vger.kernel.org
References: <201002211025.11588.rob@landley.net> <201003262235.48736.rob@landley.net> <20100326.203745.04177541.davem@davemloft.net>
In-Reply-To: <20100326.203745.04177541.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201003270244.17865.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 26 March 2010 22:37:45 David Miller wrote:
> From: Rob Landley <rob@landley.net>
> Date: Fri, 26 Mar 2010 22:35:47 -0500
>
> > What exactly was the problem with just saying "unsigned short" when you
> > mean an unsigned short?  The way x86 does, and arm?  (If these ever
> > change, it breaks binary compatability.  Not sure what these changes were
> > trying to accomplish...)
>
> I was trying to use well defined types that described the
> usage and the origin of the definition.
>
> I'm happy to use "unsigned short" or whatever works better.
> Please send a patch.

Sure thing:

--- a/arch/sparc/include/asm/stat.h
+++ b/arch/sparc/include/asm/stat.h
@@ -53,8 +53,8 @@ struct stat {
 	ino_t		st_ino;
 	mode_t		st_mode;
 	short		st_nlink;
-	uid16_t		st_uid;
-	gid16_t		st_gid;
+	unsigned short	st_uid;
+	unsigned short	st_gid;
 	unsigned short	st_rdev;
 	off_t		st_size;
 	time_t		st_atime;

Signed-off-by: Rob Landley <rob@landley.net>

Rob
-- 
Latency is more important than throughput. It's that simple. - Linus Torvalds
