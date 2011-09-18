Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756213Ab1IRP1N (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Sep 2011 11:27:13 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:63834 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754190Ab1IRP1M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Sep 2011 11:27:12 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Thomas Meyer <thomas@m3y3r.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arch@vger.kernel.org
Subject: Re: [PATCH 3/3] truncate()/ftruncate() fix length argument on ia32 emulation.
Date: Sun, 18 Sep 2011 17:26:19 +0200
Message-ID: <2572424.HyPu2df1S7@wuerfel>
User-Agent: KMail/4.7.1 (Linux/3.0.0-rc1nosema+; KDE/4.7.1; x86_64; ; )
In-Reply-To: <1316282477.5814.19.camel@localhost.localdomain>
References: <1316282477.5814.19.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:b/IDKa8aXhCxsDJZOvveJhM6OqINz8foq89I94ffygl
 GtnfkLliWU4s/PNJv8fDFl+eY+F0g3Ys5BRNQYAP3bqC21G4fI
 TnxHjEnaQ+Yf8JQ0f+H5EKPwo6XKOj2a/+7InRNclJKQQg2EBz
 6Ajdm5HyyU0KK7qwZSTkQM6A1pCyYJSzpedU/SN8AN7PcpleKs
 FYUUkkpL3MK3orBamaSiTSpiocMnQf4P4J30hyQfhrotbwUONU
 WRug05Zm1gAqQYQqRAcij4wD9isLBpwhp7Cez4N+2uNCcoMGOi
 6RJ+3W0Uvm7XtU1mOp/gyKNsiyMNde+Sukf4My5oIZQ1Yo7h52
 AERBeaJQfJNIpHa+oWsw=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 17 September 2011 20:01:17 Thomas Meyer wrote:
> move signed-extended int to long, because of signed test.
> 
> Signed-off-by: Thomas Meyer <thomas@m3y3r.de>

I would expect that the same is needed on ia64 and parisc and mips.
powerpc, s390 and sparc probably don't need it because they
have architecture specific code that already does this, but you
can probably remove the powerpc version if you add a generic
one.

New architectures (including tile) won't need the wrapper because
the 32-bit ABI there only has truncate64.

	Arnd
