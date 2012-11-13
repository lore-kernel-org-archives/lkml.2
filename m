Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753101Ab2KMDlu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 22:41:50 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:55037 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752167Ab2KMDlt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 22:41:49 -0500
Message-ID: <50A1C176.5040109@vlnb.net>
Date: Mon, 12 Nov 2012 22:41:42 -0500
From: Vladislav Bolkhovitin <vst@vlnb.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.28) Gecko/20120313 Mnenhy/0.8.5 Thunderbird/3.1.20
MIME-Version: 1.0
To: Richard Hipp <drh@sqlite.org>
CC: General Discussion of SQLite Database <sqlite-users@sqlite.org>,
        "Theodore Ts'o" <tytso@mit.edu>, drh@hwaci.com,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [sqlite] light weight write barriers
References: <CALwJ=MzHjAOs4J4kGH6HLdwP8E88StDWyAPVumNg9zCWpS9Tdg@mail.gmail.com> <m2fw5mtffg.fsf_-_@firstfloor.org> <CABK4GYNKF6LCgsQ5SN+dATtRm-0Qh_QmNdqZqZcj6S98z+ofXg@mail.gmail.com> <5086F5A7.9090406@vlnb.net> <20121025051445.GA9860@thunk.org> <508B3EED.2080003@vlnb.net> <20121027044456.GA2764@thunk.org> <5090532D.4050902@vlnb.net> <20121031095404.0ac18a4b@pyramind.ukuu.org.uk> <5092D90F.7020105@vlnb.net> <20121101212418.140e3a82@pyramind.ukuu.org.uk> <50931601.4060102@symas.com> <CALwJ=MwtFAz7uby+YzPPp2eBG-y+TUTOu9E9tEJbygDQW+s_tg@mail.gmail.com>
In-Reply-To: <CALwJ=MwtFAz7uby+YzPPp2eBG-y+TUTOu9E9tEJbygDQW+s_tg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V02:K0:gl9E5ufRDW++kVR+Ci8V0j701SXqF6+Oo1e1KonX8XZ
 qd1FRVgQP+9+LE4IUrNMNwkF3UU0TXoF4mNYyohT96+qZ1gUSU
 R/ideC7YkR19verWf8seuOLKAuplcTOJmoWEUbFLN921+zEzv2
 QGwdWdACnkGQ+ix+hK87cxRgFUbhpxjq8tAuiLASHf8+TRyaae
 xvokt1QjbIIx8NUeTs4PlHsvy578bFRZlHEjt/keI6wJnnO23k
 G94lCPbKiTXmznthogjALOpBxoUb5ZCMsP5kxzm2BlLjRgNE3d
 TwfIPkx8zyWnp4Arqk2gHHX2IMuC2HsnAMH8UQKd9v9n2gtl+a
 rbfUZd823PMfAEk8v7pg=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Richard Hipp, on 11/02/2012 08:24 AM wrote:
> SQLite cares.  SQLite is an in-process, transaction, zero-configuration
> database that is estimated to be used by over 1 million distinct
> applications and to be have over 2 billion deployments.  SQLite uses
> ordinary disk files in ordinary directories, often selected by the
> end-user.  There is no system administrator with SQLite, so there is no
> opportunity to use a dedicated filesystem with special mount options.
>
> SQLite uses fsync() as a write barrier to assure consistency following a
> power loss.  In addition, we do everything we can to maximize the amount of
> time after the fsync() before we actually do another write where order
> matters, in the hopes that the writes will still be ordered on platforms
> where fsync() is ignored for whatever reason.  Even so, we believe we could
> get a significant performance boost and reliability improvement if we had a
> reliable write barrier.

I would suggest you to forget word "barrier" for productivity sake. You don't want 
barriers and confusion they bring. You want instead access to storage accelerated 
cache sync, commands ordering and atomic attributes/operations. See my other 
today's e-mail about those.

Vlad
