Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755302Ab2K1BAO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 20:00:14 -0500
Received: from mailout39.mail01.mtsvc.net ([216.70.64.83]:36151 "EHLO
	n12.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752263Ab2K1BAK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 20:00:10 -0500
Message-ID: <1354064401.2703.13.camel@thor>
Subject: Re: [PATCH v2 1/1] staging: fwserial: Add TTY-over-Firewire serial
 driver
From: Peter Hurley <peter@hurleysoftware.com>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org, linux1394-devel@lists.sourceforge.net,
        linux-serial@vger.kernel.org
Date: Tue, 27 Nov 2012 20:00:01 -0500
In-Reply-To: <20121128005846.0f1d4d5e@stein>
References: <1350565015.23730.4.camel@thor>
	 <cover.1351817601.git.peter@hurleysoftware.com>
	 <55547e779e65e6865f18d537ef1a42191a4b7e46.1351817601.git.peter@hurleysoftware.com>
	 <20121113003338.6aafd7c8@stein> <1352834072.16401.100.camel@thor>
	 <20121114022522.633a44d4@stein> <1354041196.3284.121.camel@thor>
	 <20121128005846.0f1d4d5e@stein>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.4-0build1 
Content-Transfer-Encoding: 8BIT
Mime-Version: 1.0
X-Authenticated-User: 125194 peter@hurleysoftware.com
X-MT-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
X-MT-INTERNAL-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-11-28 at 00:58 +0100, Stefan Richter wrote:
> On Nov 27 Peter Hurley wrote:
> > > > Currently, firewire-net sets an arbitrary address handler length of
> > > > 4096. This works because the largest AR packet size the current
> > > > firewire-ohci driver handles is 4096 (value of MAX_ASYNC_PAYLOAD) +
> > > > header/trailer. Note that firewire-ohci does not limit card->max_receive
> > > > to this value.
> > > > 
> > > > So if the ohci driver changes to handle 8K+ AR packets and the hardware
> > > > supports it, these address handler windows will be too small.  
> > > 
> > > While the IEEE 1394:2008 link layer specification (section 6) provides for
> > > asynchronous packet payloads of up to 16384 bytes (table 6-4), the IEEE
> > > 1394 beta mode port specification (section 13) only allows up to 4096
> > > bytes (table 16-18).  And alpha mode is of course limited to 2048 bytes.
> > > 
> > > So, asynchronous packet payloads greater than 4096 bytes are out of scope
> > > of the current revision of IEEE 1394.  
> > 
> > You should look at this 1394ta.org video
> > http://www.youtube.com/watch?v=xVXNvXHNQTY of DAP Technologies S1600
> > OHCI controllers running S1600 cameras using beta cables.
> 
> I don't know the details of their implementation, but I suppose they conform
> with the 1394 beta mode port specification.  Which in turn means that their
> S1600 solution (and by extrapolation, their S3200 prototypes) comply with a
> maximum asynchronous packet payload of 4096 bytes.  Citing IEEE 1394-2008:
> 
> >>>
> 	Table 16-18———Maximum payload size for Beta data packets
>  Data rate | Maximum asynchronous payload size | Maximum isochronous payload
>            |              (bytes)              |           (bytes)
>  ----------+-----------------------------------+----------------------------
>     S100   |                 512               |             1024
>     S200   |                1024               |             2048
>     S400   |                2048               |             4096
>     S800   |                4096               |             8192
>     S1600  |                4096               |            16384
>     S3200  |                4096               |            32768
> <<<
> 
> (Alpha mode payload limits are the same as the S100...S400 subset of beta mode.
> In IEEE 1394b-2002, the table number is 16-3.)
> 
> You can of course define registers (or better termed: buffers) which are larger
> than what can be atomically read or written, or atomically compared-swapped;
> IOW which are larger than what can be accessed in a single transaction, if such
> registers or buffers are useful.  But if you particularly need a register which
> is just large enough to accommodate the largest possible inbound block write
> transaction which complies with IEEE 1394, and you don't know the peer's
> capability and the speeds of all intermediary cable hops, then
> fw_card.max_receive is the number that you need.  Or you ignore the cards actual
> capability and just allocate 4096 bytes.

Thanks for the clarification. I need to update
link_speed_to_max_payload() now. ;)

Plus I should just renew my IEEE membership so I can get the 1394-2008
spec without having to saw my arm off.

