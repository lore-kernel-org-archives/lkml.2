Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753455Ab1BGO6L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 09:58:11 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:49301 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752926Ab1BGO6I convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 09:58:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Rqsh+RmOHMW5YgEDHhoY4+67HvJGvSuSZ4lQhDIRwshKHeDz4FjrsYvikyNMVbQT5h
         wLF3QlOS/MfWq3EXdW/6FdIjVW1DxBG6ofbywHFuvneLcXAYdlfShLzF8SConxuI9q+m
         K5zdh4qesd2mALxVCzMPGGnWEsW1ez8V0Maw8=
MIME-Version: 1.0
In-Reply-To: <87ei7mxss8.fsf@linux.vnet.ibm.com>
References: <1296928005-9529-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	<87ei7mxss8.fsf@linux.vnet.ibm.com>
Date: Mon, 7 Feb 2011 08:58:06 -0600
Message-ID: <AANLkTi=2XB+jK_fManbO93TEbZ2=r51YR_HpWpTt8Mcx@mail.gmail.com>
Subject: Re: [V9fs-developer] [RFC PATCH -V2 0/17] Buffered write and
 writeable mmap support for 9P
From: Eric Van Hensbergen <ericvh@gmail.com>
To: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: v9fs-developer@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 5, 2011 at 12:03 PM, Aneesh Kumar K. V
<aneesh.kumar@linux.vnet.ibm.com> wrote:
> On Sat,  5 Feb 2011 23:16:28 +0530, "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com> wrote:
>> The patch series implement buffered write and writeable mmap for 9P
>>
>> Changes from V1:
>> a) Add fsync and syncfs support
>>
>
> I haven't yet addressed the previous review feedback from
> Miklos. http://article.gmane.org/gmane.linux.kernel/1093869
> Running 9p server and client on the same host even though possible
> is not a strong use case at this point. I will get to that later.
>

It is for a lot of the legacy cases including using 9p to access
user-space file servers.  Of course, there are some long standing
issues with this for anything which re-exports the name space.  Also -
most user-space file servers on the same host wouldn't want cache
support anyways.

>
> The patch series also don't address cache consistency issue that
> can arise due to direct modification in the server. I am not
> sure we need to complicate the client code for that considering
> the cache model that we follow is loose.
>

Agreed, the loose cache model doesn't respect any consistency
guarantees.  Once we implement any of the more conventional cache
policies we'll have to worry about it.

       -eric
