Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753657Ab1CVFER (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 01:04:17 -0400
Received: from sabe.cs.wisc.edu ([128.105.6.20]:37922 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753496Ab1CVFEQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 01:04:16 -0400
Message-ID: <4D882DDF.3040901@cs.wisc.edu>
Date: Tue, 22 Mar 2011 00:04:31 -0500
From: Mike Christie <michaelc@cs.wisc.edu>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
CC: linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Boaz Harrosh <bharrosh@panasas.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Andrew Morton <akpm@linux-foundation.org>,
        Douglas Gilbert <dgilbert@interlog.com>,
        Jesper Juhl <jj@chaosbits.net>
Subject: Re: [RFC-v4 11/12] iscsi-target: Add misc utility and debug logic
References: <1300613497-2091-1-git-send-email-nab@linux-iscsi.org> <1300613497-2091-12-git-send-email-nab@linux-iscsi.org> <4D881FC0.5080100@cs.wisc.edu>
In-Reply-To: <4D881FC0.5080100@cs.wisc.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/21/2011 11:04 PM, Mike Christie wrote:
>> +
>> +void iscsit_ntoa2(unsigned char *buf, u32 ip)
>> +{
>> + memset(buf, 0, 18);
>> + sprintf(buf, "%u.%u.%u.%u", ((ip>> 24)& 0xff), ((ip>> 16)& 0xff),
>> + ((ip>> 8)& 0xff), (ip& 0xff));
>> +}
>
> I think we have a function like this already.
>
>
> If not, I think this should be:
>
> sprintf(buf, "%pI4",
>
> What s up with ipv6 btw? That uses %pI6.
>


>> + if (tpg_np->tpg_np->np_sockaddr.ss_family == AF_INET6) {
>> + ip =&tpg_np->tpg_np->np_ipv6[0];
>
>
> Is ip supposed to be a string with the ip address in it? If so is that
> right? Is np_ipv6 a string with the ip address in human readable format,
> but below np_ipv4 is the integer representation then you convert it.

Ignore those, I see in the other patches it is different. Why is that?
