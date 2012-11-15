Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751946Ab2KOGPM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 01:15:12 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:51994 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751345Ab2KOGPK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 01:15:10 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: "Myklebust\, Trond" <Trond.Myklebust@netapp.com>,
        Stanislav Kinsbursky <skinsbursky@parallels.com>,
        Christoph Hellwig <hch@infradead.org>,
        "linux-nfs\@vger.kernel.org" <linux-nfs@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel\@openvz.org" <devel@openvz.org>
References: <20121106124035.GA20522@infradead.org>
	<20121106130705.GC6718@fieldses.org>
	<20121106131018.GA12211@infradead.org>
	<20121106133605.GD6718@fieldses.org>
	<20121107183355.GA7421@fieldses.org> <50A0B562.2090807@parallels.com>
	<20121114210112.GA539@fieldses.org>
	<4FA345DA4F4AE44899BD2B03EEEC2FA9092E0A40@SACEXCMBX04-PRD.hq.netapp.com>
	<20121114214236.GB539@fieldses.org>
	<4FA345DA4F4AE44899BD2B03EEEC2FA9092E0AE9@SACEXCMBX04-PRD.hq.netapp.com>
	<20121114215426.GC539@fieldses.org>
Date: Wed, 14 Nov 2012 22:14:50 -0800
In-Reply-To: <20121114215426.GC539@fieldses.org> (J. Bruce Fields's message of
	"Wed, 14 Nov 2012 16:54:26 -0500")
Message-ID: <87obize6jp.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1/doV5D5mClr377KQyml2Fq//OhC2NhMII=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_XMDrugObfuBody_08 obfuscated drug references
	*  1.6 XMSubMetaSx_00 1+ Sexy Words
	*  0.2 XMSubMetaSSx_00 1+ SortaSexy Words + 1 Sexy Word
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;"J. Bruce Fields" <bfields@fieldses.org>
X-Spam-Relay-Country: 
Subject: Re: [PATCH v3] SUNRPC: set desired file system root before connecting local transports
X-SA-Exim-Version: 4.2.1 (built Sun, 08 Jan 2012 03:05:19 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"J. Bruce Fields" <bfields@fieldses.org> writes:

> On Wed, Nov 14, 2012 at 09:51:33PM +0000, Myklebust, Trond wrote:
>> On Wed, 2012-11-14 at 16:42 -0500, J. Bruce Fields wrote:
>> > Simo's patches use them for upcalls to svcgssd.  Those will always be
>> > done from server threads.
>> 
>> Any reason why you can't set that up when you start nfsd?
>
> Oh, right, I was thinking of the upcalls themselves--right, the connect
> we should be able to do on server start, I agree.
>
>> 
>> > > If not, then let's just move
>> > > the AF_LOCAL connection back into the process context and out of rpciod.
>> > 
>> > Remind me how this helps?
>> 
>> rpciod shares the 'init' process net namespace and chroot properties.
>> If, however you call bind() from the (containerised) process that was
>> used to start nfsd, then you will be using filesystem root (and net
>> namespace) of that container.
>
> Got it.

If you can move the connect and bind into the server start that does
sound like a very good and maintainable solution.  I suspect it might
even be a smidge better for error handling.

Is there ever a reason to reconnect one of these sockets?

Eric
