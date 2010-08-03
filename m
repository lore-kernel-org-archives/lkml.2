Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756191Ab0HCNY6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 09:24:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46122 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752952Ab0HCNY5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 09:24:57 -0400
Message-ID: <4C5818A1.9070102@redhat.com>
Date: Tue, 03 Aug 2010 16:24:49 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Lightning/1.0b2pre Thunderbird/3.1.1
MIME-Version: 1.0
To: tytso@mit.edu, Christoph Hellwig <hch@infradead.org>,
        Ric Wheeler <rwheeler@redhat.com>, Mingming Cao <cmm@us.ibm.com>,
        djwong@us.ibm.com, linux-ext4 <linux-ext4@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Keith Mannthey <kmannth@us.ibm.com>, Mingming Cao <mcao@us.ibm.com>
Subject: Re: [RFC] ext4: Don't send extra barrier during fsync if there are
 no dirty pages.
References: <20100429235102.GC15607@tux1.beaverton.ibm.com> <1272934667.2544.3.camel@mingming-laptop> <4BE02C45.6010608@redhat.com> <20100504154553.GA22777@infradead.org> <20100630124832.GA1333@thunk.org>
In-Reply-To: <20100630124832.GA1333@thunk.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 06/30/2010 03:48 PM, tytso@mit.edu wrote:
>
> I wonder if it's worthwhile to think about a new system call which
> allows users to provide an array of fd's which are collectively should
> be fsync'ed out at the same time.  Otherwise, we end up issuing
> multiple barrier operations in cases where the application needs to
> do:
>
> 	fsync(control_fd);
> 	fsync(data_fd);
>

The system call exists, it's called io_submit().

-- 
error compiling committee.c: too many arguments to function

