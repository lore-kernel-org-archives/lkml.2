Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759324Ab2EKKzz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 06:55:55 -0400
Received: from mms2.broadcom.com ([216.31.210.18]:4978 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758943Ab2EKKzw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 06:55:52 -0400
X-Server-Uuid: 72204117-5C29-4314-8910-60DB108979CB
Message-ID: <4FACF02B.7070006@broadcom.com>
Date: Fri, 11 May 2012 12:55:39 +0200
From: "Arend van Spriel" <arend@broadcom.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:12.0) Gecko/20120430
 Thunderbird/12.0.1
MIME-Version: 1.0
To: "Kay Sievers" <kay@vrfy.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: in-kernel drivers and firmware loader
X-Enigmail-Version: 1.5pre
X-WSS-ID: 63B22FC344G2951314-01-01
Content-Type: text/plain;
 charset=iso-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kay,

To my memory (which fails from time to time) you posted a message on
using the asynchronous API for firmware loading as some drivers were
blocking on it in the module initialization. So for our driver we
decoupled the initialization from probe and subsequently the firmware
request. Assuming this solves the udev issue, but I am currently looking
into a somewhat related issue with our driver built-in.

I am testing on a PandaBoard which boots a linux kernel without a initrd
and our device is detected before the root filesystem is mounted. I was
expecting the async firmware request to get called back immediatly with
firmware pointer being NULL. The behaviour is slightly different as this
callback is coming after 60 seconds, which is the timeout. I guess the
uevent just gets lost without the kernel knowing it. Is that correct?

Gr. AvS

