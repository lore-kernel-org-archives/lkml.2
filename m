Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752011Ab2AVP3P (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jan 2012 10:29:15 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:62283 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751627Ab2AVP3O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jan 2012 10:29:14 -0500
MIME-Version: 1.0
Date: Sun, 22 Jan 2012 16:29:13 +0100
Message-ID: <CADDKRnDHvptV_gODG8XgqEkWGW0AyDfJJkP1dU2uBL6rs5yzDA@mail.gmail.com>
Subject: [v3.3-rc1] media:dvb-t regression bisected
From: =?ISO-8859-1?Q?J=F6rg_Otte?= <jrg.otte@googlemail.com>
To: linux-kernel@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

with v3.3-rc1 I can not watch dvb-t. I get the following
errors from the media player (Kaffeine,vlc):

kaffeine(1801): DvbDevice::frontendEvent: tuning failed
vlc: [0xa278d78] main stream error: cannot pre fill buffer

I have a CinergyT2 usb-stick.

I was able to bisect the problem to:
commit 7830bbaff9f5f9cefcdc9acfb1783b230cc69fac
Author: Mauro Carvalho Chehab <mchehab@redhat.com>
Date:   Mon Dec 26 15:41:01 2011 -0300

[media] cinergyT2-fe: convert set_fontend to use DVBv5 parameters
