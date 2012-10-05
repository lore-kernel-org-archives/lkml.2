Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755592Ab2JELza (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 07:55:30 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:51043 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755406Ab2JELz2 convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:4:1>);
	Fri, 5 Oct 2012 07:55:28 -0400
Message-Id: <506EE6CD020000780009FF4E@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Fri, 05 Oct 2012 12:55:25 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "David Vrabel" <david.vrabel@citrix.com>,
        "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>
Cc: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/6] xen-blkfront: handle backend CLOSED without
 CLOSING
References: <1348243464-15903-1-git-send-email-david.vrabel@citrix.com>
 <1348243464-15903-3-git-send-email-david.vrabel@citrix.com>
 <5061EFB2.1080407@citrix.com> <5069D097.60606@citrix.com>
 <20121002200255.GA668@phenom.dumpdata.com> <506EC79D.5080206@citrix.com>
In-Reply-To: <506EC79D.5080206@citrix.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 05.10.12 at 13:42, David Vrabel <david.vrabel@citrix.com> wrote:
> On 02/10/12 21:02, Konrad Rzeszutek Wilk wrote:
>> On Mon, Oct 01, 2012 at 06:19:19PM +0100, David Vrabel wrote:
>>> On 25/09/12 18:53, David Vrabel wrote:
>>>> On 21/09/12 17:04, David Vrabel wrote:
>>>>> From: David Vrabel <david.vrabel@citrix.com>
>>>>>
>>>>> Backend drivers shouldn't transistion to CLOSED unless the frontend is
>>>>> CLOSED.  If a backend does transition to CLOSED too soon then the
>>>>> frontend may not see the CLOSING state and will not properly shutdown.
>>>>>
>>>>> So, treat an unexpected backend CLOSED state the same as CLOSING.
>>>>
>>>> Didn't handle the frontend block device being mounted. Updated patch here.
>>>
>>> Konrad, can you ack this updated patch if you're happy with it.
>> 
>> Acked-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
>> 
>> Or should I just carry it in my for-jens-3.7 bug-fixes queue and ask
>> Jen to pull it once rc0 is out?
> 
> This seems easiest, if Jan is happy with the patch.

I see the point of your explanation yesterday, but am still not
convinced that the early cleanup in spite of active users of the
disk can't cause any problems (like dangling pointers or NULL
dereferences).

Jan

