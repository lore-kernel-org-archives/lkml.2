Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752099Ab2CKUyO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2012 16:54:14 -0400
Received: from db3ehsobe002.messaging.microsoft.com ([213.199.154.140]:3464
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751447Ab2CKUyE convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2012 16:54:04 -0400
X-SpamScore: -15
X-BigFish: VS-15(zz9371I542M1432N98dKzz1202hzzz2fh2a8h668h839h944h)
X-Forefront-Antispam-Report: CIP:131.107.125.8;KIP:(null);UIP:(null);IPV:NLI;H:TK5EX14HUBC104.redmond.corp.microsoft.com;RD:none;EFVD:NLI
From: KY Srinivasan <kys@microsoft.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
        "ohering@suse.com" <ohering@suse.com>,
        Alan Stern <stern@rowland.harvard.edu>
Subject: RE: [PATCH 2/4] Drivers: hv: Support the newly introduced KVP
 messages in the driver
Thread-Topic: [PATCH 2/4] Drivers: hv: Support the newly introduced KVP
 messages in the driver
Thread-Index: AQHM/xUgjodDttIBOEu6jGmJDxmA4pZk6SeAgABFvZCAAEJCAIAAHudA
Date: Sun, 11 Mar 2012 20:53:57 +0000
Message-ID: <6E21E5352C11B742B20C142EB499E0481B75D433@TK5EX14MBXC122.redmond.corp.microsoft.com>
References: <1331422300-4330-1-git-send-email-kys@microsoft.com>
 <1331422331-4381-1-git-send-email-kys@microsoft.com>
 <1331422331-4381-2-git-send-email-kys@microsoft.com>
 <20120311104230.GC3337@mwanda>
 <6E21E5352C11B742B20C142EB499E0481B75B403@TK5EX14MBXC122.redmond.corp.microsoft.com>
 <20120311184916.GD3337@mwanda>
In-Reply-To: <20120311184916.GD3337@mwanda>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.51.35]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Dan Carpenter [mailto:dan.carpenter@oracle.com]
> Sent: Sunday, March 11, 2012 2:49 PM
> To: KY Srinivasan
> Cc: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; virtualization@lists.osdl.org; ohering@suse.com;
> Alan Stern
> Subject: Re: [PATCH 2/4] Drivers: hv: Support the newly introduced KVP
> messages in the driver
> 
> On Sun, Mar 11, 2012 at 04:56:06PM +0000, KY Srinivasan wrote:
> > > Probably that's not enough to make a difference and we'd need to
> > > introduce a new function.
> > >
> > > Btw I don't know if utf16s_to_utf8s() counts the NUL char or not.
> > > It feels like maybe we could end up with ->value_size equal to
> > > HV_KVP_EXCHANGE_MAX_VALUE_SIZE + 1.
> >
> > The MAX value is set to accommodate the maximum string that will ever
> > be handled including the string terminator. The function utf16s_to_utf8s()
> > returns the converted string length but the returned length does not
> > include the string terminator (like strlen), hence the "+1".
> >
> 
> sprintf() and friends copy the NUL terminator but utf16s_to_utf8s()
> doesn't so the code isn't right and it does seem like maybe we could
> end up with a ->value_size equal to HV_KVP_EXCHANGE_MAX_VALUE_SIZE +
> 1.

You are right in that utf16s_to_utf8s() does not copy the string terminator. This
is not an issue in this case since the buffer for the utf8 string is zeroed out to begin
with (this memory was allocated using kzalloc()). The return value of the utf16s_to_utf8s()
is the length of the utf8s string as what would be returned by strlen. I add one to take into account
the string terminator character for further processing. As I said before the MAX value takes into
account the terminating character for all the strings handled.

Regards,

K. Y

