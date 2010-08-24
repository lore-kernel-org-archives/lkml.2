Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755217Ab0HXSIo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 14:08:44 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:53895 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751710Ab0HXSIm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 14:08:42 -0400
Message-ID: <4C740AA7.1070002@vlnb.net>
Date: Tue, 24 Aug 2010 22:08:39 +0400
From: Vladislav Bolkhovitin <vst@vlnb.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.10) Gecko/20100527 Thunderbird/3.0.5
MIME-Version: 1.0
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
CC: Dirk Meister <dmeister@uni-paderborn.de>, linux-scsi@vger.kernel.org,
        James Bottomley <James.Bottomley@suse.de>,
        Chetan Loke <chetanloke@gmail.com>,
        Chetan Loke <generationgnu@yahoo.com>,
        scst-devel <scst-devel@lists.sourceforge.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [Scst-devel] Fwd: Re: linuxcon 2010...
References: <594039.74663.qm@web111905.mail.gq1.yahoo.com>	 <1282144271.3035.31.camel@mulgrave.site>	 <AANLkTinRDMXqyDAVkcbioD=L7XO-47KHL2qjR+8KA5m3@mail.gmail.com>	 <1282148296.3035.49.camel@mulgrave.site> <4C6C1D70.7020502@vlnb.net>	 <41A1E2691BBB412BADCDE5F515CD8EDA@usish.com.cn>	 <8A96806D-6CD7-44AD-8A9D-143C098C95A4@uni-paderborn.de>	 <1282256949.30453.278.camel@haakon2.linux-iscsi.org>	 <4C701E08.2020005@vlnb.net> <1282422316.30453.498.camel@haakon2.linux-iscsi.org>
In-Reply-To: <1282422316.30453.498.camel@haakon2.linux-iscsi.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V02:K0:fW67RB/NjLo1B/qixZOTMB9b9HwLXXz9K+tExLW6b5f
 JIGf9NOFg3N/qmdHT3lZ9Hz01D33SIqS7RoI+kyPEPhgMO89Pj
 33R89p1gW0APMjv3iXfKvGgsL7i4j8FsupQtMZ4CAaWSf2MQQy
 FLHFjqA+eSP03gsiHB8OgnLqbKmpRuGzOnwEZIlGLBZzTUm6g1
 QdJsf9IMqfMeVXfdmNBEQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nicholas A. Bellinger, on 08/22/2010 12:25 AM wrote:
>> It needs a complete redesign to become fast.
>
> Secondly, not being the original author of drivers/scsi/scsi_tgt_*, I am
> happy to do the work and submit the necessary patches to achieve the
> desired goal.  Also, considering now we have the TCM v4 HBA/DEV
> abstraction with a fabric independent control path in
> target_core_fabric_configfs.c, there suddenly new interest to build upon
> tomo's and mnc'c original STGT work in drivers/scsi/scsi_tgt_*.c
>
> Using struct scsi_cmnd allocation from a specially allocated struct
> request_queue still my preferred method for doing this, unless tomo and
> mnc state otherwise.   Also if we need to change the request_queue from
> being per struct Scsi_Host to struct scsi_device that is one thing that
> will be fine.  If we need to make more drastic changes to
> drivers/scsi/scsi_tgt_if.c that is also fine.

That would be a bad design, because it would couple together 
fundamentally separate things: target and initiator subsystems (server 
and client, eg apache and firefox, sendmail and mutt, etc.). It would 
make the code harder to maintain and more fragile for modifications. On 
the user level it would lead to the need to have target mode core module 
always loaded. It is already so with STGT if you use FC or SRP. With 
them the only way to not have scsi_tgt loaded is to remove STGT on the 
compilation time.

> However saying that it needs a 'complete redesign', especially without
> ever consulting or offering to creat patches with STGT guys is not how
> mainline development functions.

Well, it isn't my habit to bother people asking something about what I 
can find an answer myself. I have spent sufficient amount of time 
hacking Linux kernel (>10 years, from which 8 in the target mode), so I 
can read others C code as easy as a book.

I've already described which flaws I see in the STGT design and nobody 
objected me (one of the objections I repeated above). You can find my 
messages in the list archive. Isn't answering on exact critics a way how 
a cooperative development is supposed to be done? If somebody comes with 
a better solution for an existing problem is he supposed be ignored? Is 
it the way how the mainline development functions?

>> In
>> contrast, interface provided by scst_user has just 3% overhead comparing
>> with fully in-kernel backend and allows to build storage capable of
>> handling 1,500,000 IOPSes (Kaminario).
>
> Please understand that you are more than welcome to create your
> own TCM subsystem plugin for your SCST kernel<->  user passthrough
> interface so it can take advantage of all the drivers/target/ code has
> to offer.

Well, please understand that you are more than welcome to stop 
reinventing a wheel and instead just have the functionality and the 
advantages you referring already long ago implemented in SCST and being 
used to build (using your expression) records breaking storage products. 
You are also more than welcome to add the only extra functionality LIO 
has over SCST, ALUA, into SCST. Your patches are always welcome.

Vlad
