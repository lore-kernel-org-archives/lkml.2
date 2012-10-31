Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423106Ab2JaPFQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 11:05:16 -0400
Received: from caibbdcaaaaf.dreamhost.com ([208.113.200.5]:56410 "EHLO
	homiemail-a82.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1423084Ab2JaPFN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 11:05:13 -0400
X-Greylist: delayed 331 seconds by postgrey-1.27 at vger.kernel.org; Wed, 31 Oct 2012 11:05:13 EDT
Message-ID: <50913E24.1010009@shealevy.com>
Date: Wed, 31 Oct 2012 11:05:08 -0400
From: Shea Levy <shea@shealevy.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20121020 Thunderbird/15.0.1
MIME-Version: 1.0
To: Matthew Garrett <mjg59@srcf.ucam.org>
CC: Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org
Subject: Re: [RFC] Second attempt at kernel secure boot support
References: <1348152065-31353-1-git-send-email-mjg@redhat.com> <alpine.LRH.2.00.1210290848450.10392@twin.jikos.cz> <20121029174131.GC7580@srcf.ucam.org> <alpine.LNX.2.00.1210311444080.12781@pobox.suse.cz> <20121031150201.GA12394@srcf.ucam.org>
In-Reply-To: <20121031150201.GA12394@srcf.ucam.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/31/2012 11:02 AM, Matthew Garrett wrote:
> On Wed, Oct 31, 2012 at 03:50:00PM +0100, Jiri Kosina wrote:
>
>> Reading stored memory image (potentially tampered before reboot) from disk
>> is basically DMA-ing arbitrary data over the whole RAM. I am currently not
>> able to imagine a scenario how this could be made "secure" (without
>> storing private keys to sign the hibernation image on the machine itself
>> which, well, doesn't sound secure either).
> shim generates a public and private key. It hands the kernel the private
> key in a boot parameter and stores the public key in a boot variable. On
> suspend, the kernel signs the suspend image with that private key and
> discards it. On the next boot, shim generates a new key pair and hands
> the new private key to the kernel along with the old public key. The
> kernel verifies the suspend image before resuming it. The only way to
> subvert this would be to be able to access kernel memory

Or the boot variable where you stored the key, but in that case I'd say 
the attacker has won too.

>   directly, which
> means the attacker has already won.
>
> Now someone just needs to write it.
>

