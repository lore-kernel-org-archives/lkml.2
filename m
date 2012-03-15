Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032428Ab2COXgZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 19:36:25 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:1535 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1031246Ab2COXgX convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 19:36:23 -0400
X-SpamScore: -15
X-BigFish: VS-15(zz9371I542M1432N98dKzz1202hzz8275dhz2fh2a8h668h839h944hd25h)
X-Forefront-Antispam-Report: CIP:131.107.125.8;KIP:(null);UIP:(null);IPV:NLI;H:TK5EX14MLTC103.redmond.corp.microsoft.com;RD:none;EFVD:NLI
From: KY Srinivasan <kys@microsoft.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "ohering@suse.com" <ohering@suse.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>
Subject: RE: [PATCH 2/4] Drivers: hv: Support the newly introduced KVP
 messages in the driver
Thread-Topic: [PATCH 2/4] Drivers: hv: Support the newly introduced KVP
 messages in the driver
Thread-Index: AQHM/xUgjodDttIBOEu6jGmJDxmA4pZk6SeAgABFvZCAAEJCAIAAHudAgACR+4CAAHKdUIAADleAgAVmLaA=
Date: Thu, 15 Mar 2012 23:36:16 +0000
Message-ID: <6E21E5352C11B742B20C142EB499E0481B7663B1@TK5EX14MBXC126.redmond.corp.microsoft.com>
References: <1331422300-4330-1-git-send-email-kys@microsoft.com>
 <1331422331-4381-1-git-send-email-kys@microsoft.com>
 <1331422331-4381-2-git-send-email-kys@microsoft.com>
 <20120311104230.GC3337@mwanda>
 <6E21E5352C11B742B20C142EB499E0481B75B403@TK5EX14MBXC122.redmond.corp.microsoft.com>
 <20120311184916.GD3337@mwanda>
 <6E21E5352C11B742B20C142EB499E0481B75D433@TK5EX14MBXC122.redmond.corp.microsoft.com>
 <20120312052221.GE3337@mwanda>
 <6E21E5352C11B742B20C142EB499E0481B75D4CE@TK5EX14MBXC122.redmond.corp.microsoft.com>
 <20120312130353.GF3337@mwanda>
In-Reply-To: <20120312130353.GF3337@mwanda>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.51.19]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Dan Carpenter [mailto:dan.carpenter@oracle.com]
> Sent: Monday, March 12, 2012 9:04 AM
> To: KY Srinivasan
> Cc: gregkh@linuxfoundation.org; ohering@suse.com; linux-
> kernel@vger.kernel.org; virtualization@lists.osdl.org; Alan Stern;
> devel@linuxdriverproject.org
> Subject: Re: [PATCH 2/4] Drivers: hv: Support the newly introduced KVP
> messages in the driver
> 
> On Mon, Mar 12, 2012 at 12:36:53PM +0000, KY Srinivasan wrote:
> > Dan,
> > I am sorry for not being as precise as I should be:
> > utf16s_to_utf8s() takes two length parameters - the length of the utf16 string
> > that is to be converted and the second the length of the utf8 output string.
> > The windows host manipulates all string in utf16 encoding and the string we get
> > from the host is guaranteed to be less than or equal to MAX value that we have
> > including the terminating character. In my code, I simply pass the length of the
> > utf16 string as received from the host.
> >
> > The parameter that I am currently passing MAX length value is the "maxout"
> > parameter of the utf16s_utf8s() function. This by definition is the size of the
> > output buffer and in this case it happens to be MAX characters big.
> >
> 
> I also think I'm not being as clear as I should...  I understand
> that you trust the input; I'm say that for correctness sake you
> should specify a output size which leaves room for the NUL char.
> 
> I can't say I know this code very well so I could be wrong, but it's
> what we do inside usb_string() for example.  Can someone who knows
> the code check if we should do something like this:
> 

Dan, 

Sorry I could not get back to you earlier. You are right, in that I am trusting
the host! I am of the firm belief that in a virtualized environment, if you don't trust
the host, there is not a whole lot you can do in a guest! I have had this arguments 
with other on this mailing list in the past. Having said that, I think we have spent more
time debating this than we should; your proposal is reasonable and I will go ahead and
re-spin those patches based on your comments. I should be posting them shortly.

Regards,

K. Y

