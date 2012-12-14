Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756242Ab2LNPYy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 10:24:54 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:37018 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755955Ab2LNPYw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 10:24:52 -0500
Date: Fri, 14 Dec 2012 15:30:00 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Pavel Shilovsky <piastry@etersoft.ru>
Cc: David Laight <david@l8s.co.uk>, Christoph Hellwig <hch@infradead.org>,
        linux-fsdevel@vger.kernel.org, linux-cifs@vger.kernel.org,
        linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        wine-devel@winehq.org
Subject: Re: [PATCH 0/3] Add O_DENY* flags to fcntl and cifs
Message-ID: <20121214153000.62af6cbc@pyramind.ukuu.org.uk>
In-Reply-To: <CAKywueSN++ZCNJ1zbET_axuwXd2ZujvSof9H82E3AdeZWY_BgQ@mail.gmail.com>
References: <1354818391-7968-1-git-send-email-piastry@etersoft.ru>
	<20121207161602.GA17710@infradead.org>
	<495d17310e0a687d446afc86def0f058@office.etersoft.ru>
	<20121212083401.GW5010@snowdrop.l8s.co.uk>
	<CAKywueSN++ZCNJ1zbET_axuwXd2ZujvSof9H82E3AdeZWY_BgQ@mail.gmail.com>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> We can make this feature (passing O_DENY* flags received from clients
> to filesystem) can be turned on/off on Samba/NFS server to let this
> particular use case work. In general, I think we really need to be
> sure that nobody has a read access for files that a Windows process
> opened with O_DENYREAD (because there can be important reasons for the
> Windows process to do so).

It should only affect windows emulated tasks, nothing else. If you want
to do locking friendly behaviour you could also take lockf locks so that
Linux domain code that *wishes* to be nice in this area behaves the way
you want.

Without that you break so much stuff its a horrible idea (eg backups,
ubuntu one sync etc).

Alan

