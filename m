Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757322Ab1FQHWF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 03:22:05 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:35494 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756773Ab1FQHWA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 03:22:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=nrys08uHAV1KPp70RFoex87H97kA+YJuOTpkj8zi5Oep1tH6XrXaw06bOVXMHaJWxa
         HFEleYu+zbkMgVjuIiyHGg85a06oHOWagUxamuebicrA88zHK3TXjJS/lDuvF3DLjwdW
         F20e28ozM3A1AVGkxqH/fGuJRNcntja3/jH80=
Message-ID: <4DFB0094.7010605@garzik.org>
Date: Fri, 17 Jun 2011 03:21:56 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Thunderbird/3.1.10
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Christoph Hellwig <hch@infradead.org>, Pekka Enberg <penberg@kernel.org>,
        Anthony Liguori <anthony@codemonkey.ws>,
        Alexander Graf <agraf@suse.de>,
        Prasad Joshi <prasadjoshi124@gmail.com>, Avi Kivity <avi@redhat.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <levinsasha928@gmail.com>,
        Cyrill Gorcunov <gorcunov@gmail.com>, Asias He <asias.hejun@gmail.com>,
        Jens Axboe <jaxboe@fusionio.com>
Subject: Re: [ANNOUNCE] Native Linux KVM tool v2
References: <7A30A509-47AA-4E72-ABF3-937005900F9D@suse.de> <4DF93010.1040006@codemonkey.ws> <4DF935C1.4020000@codemonkey.ws> <BANLkTikmUpF_fsZcpiuMzZQZa17U-cPQAw@mail.gmail.com> <BANLkTi=mS43KwRG13ROmZX+HmbrPMVgV=g@mail.gmail.com> <20110616092429.GA5484@infradead.org> <BANLkTinnSW=EEunCu_d51Mapiv=V03ncQw@mail.gmail.com> <20110616094810.GA19965@infradead.org> <BANLkTikoMZCFzA6jUw+ddHZ3x2cvO_NzhA@mail.gmail.com> <20110616100239.GA29262@infradead.org> <20110616112230.GD26110@elte.hu>
In-Reply-To: <20110616112230.GD26110@elte.hu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/16/2011 07:22 AM, Ingo Molnar wrote:
>
> * Christoph Hellwig<hch@infradead.org>  wrote:
>
>> On Thu, Jun 16, 2011 at 12:57:36PM +0300, Pekka Enberg wrote:
>>> Uh-oh. Someone needs to apply this patch to sync_file_range():
>>
>> There actually are a few cases where using it makes sense. [...]
>
> Such as? I don't think apps can actually know whether disk blocks
> have been 'instantiated' by a particular filesystem or not, so the
> manpage:
>
>     Some details
>         None  of these operations write out the file’s metadata.  Therefore, unless the appli-
>         cation is strictly performing overwrites of already-instantiated  disk  blocks,  there
>         are no guarantees that the data will be available after a crash.
>
> is rather misleading. This is a dangerous (and rather pointless)
> syscall and this should be made much clearer in the manpage.

Not pointless at all -- see Linus's sync_file_range() examples in "Re: 
Unexpected splice "always copy" behavior observed" thread from May 2010.

Apps like MythTV may use it for streaming data to disk, basically 
shoving the VM out of the way to give the app more fine-grained writeout 
control.

Just don't mistake sync_file_range() for a data integrity syscall.

	Jeff



