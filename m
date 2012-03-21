Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754104Ab2CUPnD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 11:43:03 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:56209 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751457Ab2CUPnB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 11:43:01 -0400
X-Authenticated: #1226656
X-Provags-ID: V01U2FsdGVkX19ToQs238pTOTwGiI9tXR7XmRXFFbUC0DpD1PpGRt
	4xdkRIHfx55VLh
Date: Wed, 21 Mar 2012 16:42:52 +0100
From: Marc Giger <gigerstyle@gmx.ch>
To: linux-kernel@vger.kernel.org
Subject: Missing inotify events
Message-ID: <20120321164252.7b5ff276@rigi.itserve.ch>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I have a Java application which writes multiple files in a short period of time. When I watch the
filechanges with inotifywait sometimes events are missing. To find out what's going on I straced
the java application to see if the files are e.g. properly closed:

26467 open("/tmp/refapps2/20051002/giger/documents/891877A1C3FB7CEA477B/1332340770691_Ping_unknown_TransmitterRequestRaw_UTF-8.xml", O_WRONLY|O_CREAT|O_TRUNC, 0666) = 804
26467 close(804)                        = 0
26467 open("/tmp/refapps2/20051002/giger/documents/891877A1C3FB7CEA477B/1332340770728_PingResponse_unknown_TransmitterResponseRaw_UTF-8.xml", O_WRONLY|O_CREAT|O_TRUNC, 0666) = 805
26467 close(805)

inotifywait reports:

/tmp/refapps2/20051002/giger/documents/ CREATE,ISDIR 891877A1C3FB7CEA477B
/tmp/refapps2/20051002/giger/documents/ OPEN,ISDIR 891877A1C3FB7CEA477B
/tmp/refapps2/20051002/giger/documents/ CLOSE_NOWRITE,CLOSE,ISDIR 891877A1C3FB7CEA477B
/tmp/refapps2/20051002/giger/documents/891877A1C3FB7CEA477B/ CREATE 1332340770728_PingResponse_unknown_TransmitterResponseRaw_UTF-8.xml
/tmp/refapps2/20051002/giger/documents/891877A1C3FB7CEA477B/ OPEN 1332340770728_PingResponse_unknown_TransmitterResponseRaw_UTF-8.xml
/tmp/refapps2/20051002/giger/documents/891877A1C3FB7CEA477B/ MODIFY 1332340770728_PingResponse_unknown_TransmitterResponseRaw_UTF-8.xml
/tmp/refapps2/20051002/giger/documents/891877A1C3FB7CEA477B/ CLOSE_WRITE,CLOSE 1332340770728_PingResponse_unknown_TransmitterResponseRaw_UTF-8.xml

This behavior can be repeated easily, but not that easy when running the app under strace (timing issue?).

I would expect that I get _all_ events as long as the event-queue is not full. No?

Ubuntu Kernel 2.6.32-37-server and also vanilla-kernel 3.2.6 running gentoo behave the same way.


Marc

