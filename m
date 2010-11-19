Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755578Ab0KSQAa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 11:00:30 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:64463 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755376Ab0KSQA0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 11:00:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=o5mf91wkA/QUxjA9909TJuG8GgE8X1H+A7Rm13Ee5Jm38KwmeG2jKn9wFMRlTBRQd4
         AqaZqKDbSznzxCBzxC3dATAiA+KSFy/vn3He6ajKSg8d5MQ9DRtBJhOZ5/VuCqcjaoti
         DkjRIMCiC8pX8eWAW/dwHjJJnfIKE9Tk3KsiE=
MIME-Version: 1.0
In-Reply-To: <4CE698C5.5060806@kernel.org>
References: <20101104164401.GC10656@sundance.ccs.neu.edu>
	<4CD3CE29.2010105@kernel.org>
	<20101106053204.GB12449@count0.beaverton.ibm.com>
	<20101106204008.GA31077@sundance.ccs.neu.edu>
	<4CD5D99A.8000402@cs.columbia.edu>
	<20101107184927.GF31077@sundance.ccs.neu.edu>
	<4CD72150.9070705@cs.columbia.edu>
	<4CE3C334.9080401@kernel.org>
	<20101117153902.GA1155@hallyn.com>
	<4CE3F8D1.10003@kernel.org>
	<20101119041045.GC24031@hallyn.com>
	<4CE683E1.6010500@kernel.org>
	<04F4899E-B5C7-4BAF-8F2F-05D507A91408@parallels.com>
	<4CE698C5.5060806@kernel.org>
Date: Fri, 19 Nov 2010 18:00:22 +0200
Message-ID: <AANLkTikRHuaCpaROtty6X_Oe6JixzgcbVsxHxvtsu+UV@mail.gmail.com>
Subject: Re: [Ksummit-2010-discuss] checkpoint-restart: naked patch
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Kirill Korotaev <dev@parallels.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Kapil Arya <kapil@ccs.neu.edu>, Gene Cooperman <gene@ccs.neu.edu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Pavel Emelianov <xemul@parallels.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Linux Containers <containers@lists.osdl.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 19, 2010 at 5:33 PM, Tejun Heo <tj@kernel.org> wrote:
>> - insert SKB's into socket buffers
>
> Can't we drain kernel buffers?  ie. Stop further writing and wait the
> send-q to drop to zero.

On send:
if network dies right after freeze, you lose.

On receive:
packets arrive after process freeze, but before network device freeze.

>> - setting different statistics counters (like netdev stats etc.)
>> and so on...
>
> Why would this matter?

Because you'll introduce million stupid interfaces not interesting to
anyone but C/R.
