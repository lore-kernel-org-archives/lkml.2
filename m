Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753129Ab1AONeN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jan 2011 08:34:13 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:38346 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752818Ab1AONeM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jan 2011 08:34:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=vFsKUh5YRaPdFh96pCvCdy8nPP0eKqU+5iAtM0EZ+S1QpqtO1Ok+4CAaVJlTZJExku
         /FEYqHjfofrPu1WMLnQmmy7vZs0LxBEzDEFGygmS8P8VbF3p2bKLmWbcwLhDBOYyYWsk
         zjZmePCanTu93DERBRFwkmxkRLhpeIiXmBtxI=
MIME-Version: 1.0
In-Reply-To: <201101131423.51640.helmut.schaa@googlemail.com>
References: <m31v4hkmkf.fsf@ingo.homenetwork>
	<201101131423.51640.helmut.schaa@googlemail.com>
Date: Sat, 15 Jan 2011 14:34:11 +0100
Message-ID: <AANLkTimMVdsGONSD9OmnX2eJk51H5Pzj4K8irHa=E-qx@mail.gmail.com>
Subject: Re: BUG in rt2x00lib_txdone() with 2.6.37-rc8
From: Ivo Van Doorn <ivdoorn@gmail.com>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: Ingo Brunberg <ingo_brunberg@web.de>, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> Just a shot in the dark but since the stack trace shows the newly added
> watchdog this might be the result of a race between a regular txdone work
> (mac80211 workqueue) vs the watchdog work (global workqueue).
>
> I guess the following situation could happen:
> A regular tx done work calls rt2x00lib_txdone which first sets entry->skb to
> NULL, calls the driver specific clear_entry and afterwards increases
> Q_INDEX_DONE. If the watchdog work calls rt2x00lib_txdone on a different CPU
> inbetween the skb might be NULL and cause the above oops.

This could be, would be interesting to know if compat-wireless also shows
this problem. Because the queue refactoring code which should have solved
these race conditions was added after 2.6.37.

Ivo
