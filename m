Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755838Ab2GDUTc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 16:19:32 -0400
Received: from georges.telenet-ops.be ([195.130.137.68]:49095 "EHLO
	georges.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755781Ab2GDUTb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 16:19:31 -0400
Message-ID: <1341433169.4131.13.camel@piranha.localdomain>
Subject: Re: Logitech HD Webcam C525 does not work when connected to USB 2
 port, works on USB 3
From: Frederik Himpe <fhimpe@telenet.be>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-uvc-devel@lists.sourceforge.net
Date: Wed, 04 Jul 2012 22:19:29 +0200
In-Reply-To: <Pine.LNX.4.44L0.1207041425330.15857-100000@netrider.rowland.org>
References: <Pine.LNX.4.44L0.1207041425330.15857-100000@netrider.rowland.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-07-04 at 14:42 -0400, Alan Stern wrote:
> On Wed, 4 Jul 2012, Frederik Himpe wrote:
> 
> > > What happens if you disable USB runtime suspend on the affected system?  
> > > Windows tends not to use it.
> > 
> > It appears to make a difference, but it still does not work perfectly.
> > 
> > I disabled autosuspend like this:
> > root@piranha:/sys# for i in $(find -name autosuspend); do echo 0 > $i; done
> 
> That doesn't disable autosuspend.  The proper way is:
> 
> 	echo on >/sys/bus/usb/devices/.../power/control
> 
> where you fill in the "..." with the directory name for the webcam.

usb trace from trying mplayer a few times after disabling autosuspend:

ffff880415761ec0 897158138 S Ii:1:081:7 -115:128 16 <
ffff8803c49ec800 897158252 S Co:1:081:0 s 21 01 0100 0003 001a 26 = 01000101 15160500 00000000 00000000 00000000 00000000 0000
ffff8803c49ec800 897162252 C Co:1:081:0 -71 0
ffff8803c49ec800 897162388 S Co:1:081:0 s 01 0b 0000 0003 0000 0
ffff8803c49ec800 897166377 C Co:1:081:0 -71 0
ffff880415761ec0 897166486 C Ii:1:081:7 -2:128 0
ffff880415761ec0 897844606 S Ii:1:081:7 -115:128 16 <
ffff8803c49ec800 897844749 S Co:1:081:0 s 21 01 0100 0003 001a 26 = 01000101 15160500 00000000 00000000 00000000 00000000 0000
ffff8803c49ec800 897848746 C Co:1:081:0 -71 0
ffff8803c49ec800 897848879 S Co:1:081:0 s 01 0b 0000 0003 0000 0
ffff8803c49ec800 897852873 C Co:1:081:0 -71 0
ffff880415761ec0 897852965 C Ii:1:081:7 -2:128 16 = 0000e83f 335dbc5f f438be84 08004500
ffff880415761ec0 898444380 S Ii:1:081:7 -115:128 16 <
ffff8803c49ecd40 898444471 S Co:1:081:0 s 21 01 0100 0003 001a 26 = 01000101 15160500 00000000 00000000 00000000 00000000 0000
ffff8803c49ecd40 898448507 C Co:1:081:0 -71 0
ffff8803c49ecd40 898448639 S Co:1:081:0 s 01 0b 0000 0003 0000 0
ffff8803c49ecd40 898452616 C Co:1:081:0 -71 0
ffff880415761ec0 898452722 C Ii:1:081:7 -2:128 0
ffff880415761ec0 899007841 S Ii:1:081:7 -115:128 16 <
ffff8803c49ec800 899007939 S Co:1:081:0 s 21 01 0100 0003 001a 26 = 01000101 15160500 00000000 00000000 00000000 00000000 0000
ffff8803c49ec800 899011863 C Co:1:081:0 -71 0
ffff8803c49ec800 899012005 S Co:1:081:0 s 01 0b 0000 0003 0000 0
ffff8803c49ec800 899015986 C Co:1:081:0 -71 0
ffff880415761ec0 899016082 C Ii:1:081:7 -2:128 0

dmesg contains:
[ 9146.620398] uvcvideo: Failed to set UVC probe control : -71 (exp. 26).

-- 
Frederik Himpe <fhimpe@telenet.be>

