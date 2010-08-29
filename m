Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753251Ab0H2MUd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Aug 2010 08:20:33 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:55627 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753138Ab0H2MUb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Aug 2010 08:20:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=ExeQy9pNAQLY5/k6jsPGsjJ+cWiH0pUkequw4WHMBmsDEY3jAlJYfZxw+3YeCdrWze
         oXFgyr9WqUmu1pdRj3ogN2v8i7U7lmGiFLQb9rA44Cl3NoP6Vshyt8kbb8KZDPbJkLKr
         OaBehnvO5oeSPHJW/y6Lz0jclcliUWKR4rHiI=
Subject: Re: [PATCH] Add quick erase format option
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Stefani Seibold <stefani@seibold.net>
Cc: David Woodhouse <dwmw2@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "Enzinger, Robert (EXT-Other - DE/Munich)" 
	<robert.enzinger.ext@nsn.com>
In-Reply-To: <1283081435.2131.24.camel@brekeke>
References: <1281342353-18180-1-git-send-email-stefani@seibold.net>
	 <1281343038.12908.25.camel@localhost>
	 <1281343974.18398.13.camel@wall-e.seibold.net>
	 <1281353344.2332.8.camel@brekeke>
	 <1281362069.20181.16.camel@wall-e.seibold.net>
	 <1283081435.2131.24.camel@brekeke>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 29 Aug 2010 15:20:24 +0300
Message-ID: <1283084424.2131.40.camel@brekeke>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 (2.30.2-4.fc13) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-08-29 at 14:30 +0300, Artem Bityutskiy wrote:
> The reason why this flushing is needed is that we want to make sure
> that
> there are no PEBs which belonged to a volume with the same ID. Indeed,
> imaging you have volume 5 with many used LEBs. Then you remove this
> volume, so that all its LEBs are scheduled for erasure. Then you
> create
> a new volume with the same ID = 5. If we do not flush the queue, we
> may
> end up with rubbish from the older volume 5 in the new one. 

Err, it is important to say that we'll end up with the rubbish if we
have an unclean reboot after the new volume with ID 5 is created, but
before all PEBs belonging to the old volume with ID 5 are erased.
Hopefully, my explanation is not too messy :-)

-- 
Best Regards,
Artem Bityutskiy (Битюцкий Артём)

