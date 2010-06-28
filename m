Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753020Ab0F1NHc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 09:07:32 -0400
Received: from esgaroth.petrovitsch.at ([78.47.184.11]:5577 "EHLO
	esgaroth.petrovitsch.priv.at" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751284Ab0F1NHa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 09:07:30 -0400
X-DKIM: Sendmail DKIM Filter v2.8.3 unknown-host o5SD2cSv016561
Subject: Re: [PATCH 5/5]bluetooth:hci_bcsp Fix operation on
 'bcsp->msgq_txseq' may be undefined
From: Bernd Petrovitsch <bernd@petrovitsch.priv.at>
To: David Howells <dhowells@redhat.com>
Cc: "Justin P. Mattock" <justinmattock@gmail.com>,
       "Gustavo F. Padovan" <gustavo@padovan.org>,
       linux-kernel@vger.kernel.org, sds@tycho.nsa.gov, lenb@kernel.org,
       linux-bluetooth@vger.kernel.org
In-Reply-To: <7323.1277729576@redhat.com>
References: <1277621246-10960-6-git-send-email-justinmattock@gmail.com>
	 <1277621246-10960-1-git-send-email-justinmattock@gmail.com>
	 <7323.1277729576@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 28 Jun 2010 15:02:38 +0200
Message-ID: <1277730158.3831.17.camel@thorin>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
X-DCC-debian-Metrics: esgaroth.petrovitsch.priv.at; whitelist
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-06-28 at 13:52 +0100, David Howells wrote:
> Justin P. Mattock <justinmattock@gmail.com> wrote:
> 
> > -		BT_DBG("Sending packet with seqno %u", bcsp->msgq_txseq);
> > -		bcsp->msgq_txseq = ++(bcsp->msgq_txseq) & 0x07;
> > +		BT_DBG("Sending packet with seqno %u", bcsp->msgq_txseq | ret);
> > +		ret = ++(bcsp->msgq_txseq) & 0x07;
> 
> I don't know what you're trying to do here, but you seem to be trying to send
> the computed value back in time.
> 
> The problem is that the compiler is confused about why a '++' operator makes

It's even worse as that expression is explicitly undefined (and should
be fixed anyways and unconditionally).

> any sense here.  It doesn't.  It should be a '+ 1' instead.  I think what you
> want is:
> 
> 	-	bcsp->msgq_txseq = ++(bcsp->msgq_txseq) & 0x07;
> 	+	bcsp->msgq_txseq = (bcsp->msgq_txseq + 1) & 0x07;

Yes, that's looks like the most probable intention of it - at least for
one who doesn't know the bluetooth code.

	Bernd
-- 
Bernd Petrovitsch                  Email : bernd@petrovitsch.priv.at
                     LUGA : http://www.luga.at

