Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757307Ab2CQM5L (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Mar 2012 08:57:11 -0400
Received: from vm1.a6n.de ([78.46.59.250]:35917 "EHLO vm1.a6n.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753597Ab2CQM5G convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Mar 2012 08:57:06 -0400
X-Greylist: delayed 1668 seconds by postgrey-1.27 at vger.kernel.org; Sat, 17 Mar 2012 08:57:05 EDT
Subject: Faulty has_zero()? (was: .. anybody know of any filesystems that depend on the exact VFS 'namehash' implementation?)
Mime-Version: 1.0 (Apple Message framework v1257)
Content-Type: text/plain; charset=US-ASCII
From: Sven Anderson <sven@anderson.de>
In-Reply-To: <CA+55aFwHN_4=WOOYVC60kdSfwYautigNwTwUnjQDRa-oTanVog@mail.gmail.com>
Date: Sat, 17 Mar 2012 13:29:08 +0100
Cc: Chris Mason <chris.mason@oracle.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Transfer-Encoding: 7BIT
Message-Id: <FA611BE7-A574-444D-9C1E-7E32CB3BD659@anderson.de>
References: <CA+55aFyv=OKUuAV6pqdmbHeUL7Motsh+n026nWqaT63aEgBjBQ@mail.gmail.com> <20120301165726.GF23916@ZenIV.linux.org.uk> <CA+55aFzxWifxyFSpQfuztmOiyBQpYfiM560DWXoooZ8j8p3fYw@mail.gmail.com> <20120301183403.GF5054@shiny> <CA+55aFwHN_4=WOOYVC60kdSfwYautigNwTwUnjQDRa-oTanVog@mail.gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
X-Mailer: Apple Mail (2.1257)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Am 01.03.2012 um 23:42 schrieb Linus Torvalds:

> +/* Return the high bit set in the first byte that is a zero */
> +static inline unsigned long has_zero(unsigned long a)
> +{
> +	return ((a - ONEBYTES) & ~a) & HIGHBITS;
> +}

(I commented this on your google+ posting as well, but I'm not sure if you will notice it there.)

Out of curiosity I studied your code, and if I'm not mistaken your has_zero() function doesn't do what is expected. If there are leading 0x01 bytes in front of a NUL byte, they are also marked in the mask because of the borrow bit. You could argue, that there are no 0x01 bytes in path stings, and I agree (even with UTF-8). But you also use it for slash detection, and there you have the same effect with the '.' char, since '.' ^ '/' == 0x01. So if you have a directory name like "foobar.../" it will get handled the same as "foobar////".


Best regards

Sven

