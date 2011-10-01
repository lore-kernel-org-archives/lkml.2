Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754325Ab1JAQ5N (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Oct 2011 12:57:13 -0400
Received: from 1wt.eu ([62.212.114.60]:33294 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752009Ab1JAQ5F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Oct 2011 12:57:05 -0400
Date: Sat, 1 Oct 2011 18:56:59 +0200
From: Willy Tarreau <w@1wt.eu>
To: Greg KH <greg@kroah.com>
Cc: akwatts@ymail.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: kernel.org status: hints on how to check your machine for intrusion
Message-ID: <20111001165659.GB18690@1wt.eu>
References: <4E8655CD.90107@zytor.com> <20110930235924.GA25176@kroah.com> <20111001141751.GA8937@zeus> <20111001142848.GA27058@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111001142848.GA27058@kroah.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 01, 2011 at 07:28:48AM -0700, Greg KH wrote:
> On Sat, Oct 01, 2011 at 09:17:51AM -0500, akwatts@ymail.com wrote:
> > Greg, many thanks for providing these helpful hints for assessing 
> > system integrity.
> > 
> > On Fri, Sep 30, 2011 at 04:59:24PM -0700, Greg KH wrote:
> > > The compromise of kernel.org and related machines has made it clear that
> > > some developers, at least, have had their systems penetrated.  As we
> > > seek to secure our infrastructure, it is imperative that nobody falls
> > > victim to the belief that it cannot happen to them.  We all need to
> > > check our systems for intrusions.  Here are some helpful hints as
> > > proposed by a number of developers on how to check to see if your Linux
> > > machine might be infected with something:
> > 
> > I understand that git repos are protected from ex-post tampering by a
> > rolling sha-1 hash. However, is it possible that code submissions were
> > faked during the intrusion window and pulled by legitimate subsystem
> > or system managers?
> > 
> > The intrusion on kernel.org has been dated as potentially weeks
> > before 8/28 which means many tarballs (that common users rely on more
> > than git) were posted after that.
> > 
> > Can we confirm a few things?
> 
> At this time, we are unable to discuss the events that took place due
> to an ongoing investigation into the matter.  After that is complete, I
> will be working to provide a report of what happened, but that will take
> some time.
> 
> When www.kernel.org and git.kernel.org come back up, the kernels on them
> will have been checked to be verified to be correct.  Everyone involved
> is working as hard as they can to make that happen as soon as is
> possible.
> 
> > c) can someone with verifiably clean code (i.e. not just downloads from
> >    kernel.org) post checksums (md5,sha1,rmd160) for official tarball
> >    releases since say 3/2011 (both full kernel and patches)?
> 
> You can do this today yourself from Linus's git tree if you want to,
> it's very easy to script.  Just watch out for the fact that gzip puts
> dates into the header, so you need to check the .tar file, not the
> compressed ones.

Here's what I've done on my side on the tags I had :

  for i in $(git tag|grep ^v[23]|grep -v pre|grep -v rc); do
    echo -n "${i#v} "
    git archive --format tar --prefix linux-${i#v}/ $i | md5sum
  done

On the 2.4 repo, here are the md5 outputs :

  2.4.32 f61801c23a59377de9dbae622ffc4ea7  -
  2.4.33 4cf5ea87123b8683628545288e4250ec  -
  2.4.34 46350ec55391a9d2a44507d130a98462  -
  2.4.35 373ea382a7437a2a431e2aa4eb1c6306  -
  2.4.35.1 cf6632ac5f580a53909c01e600e2d8a0  -
  2.4.35.2 de26727b0a6123a01f1de178bc403960  -
  2.4.35.3 2e7493ebd8df7414cdfbbbe77b4ab63e  -
  2.4.35.4 396a157f51cc1e62a6764a8ad98c98d1  -
  2.4.35.5 433b3b235d54d8891033581459479dd0  -
  2.4.36 13770787fe7fa2c99824eee5ad7fc43d  -
  2.4.36.1 4d8bf038ba2be8f9f5ceda3dd569c472  -
  2.4.36.2 5683ba1cbc87147b7b823ba21d583aa2  -
  2.4.36.3 cbf7e13926cfe33aefc795bd8c044a92  -
  2.4.36.4 6e3c826a3bae477281e43e9cf6824fe6  -
  2.4.36.5 6f390c5c278b3e858a0473e45da70b2c  -
  2.4.36.6 766a950b86c7933c500aeb1691734fa0  -
  2.4.36.7 9aa935e267aebd4048127041c1e86f99  -
  2.4.36.8 0978df7d54780fabc688e12dc393e7a0  -
  2.4.37 ed4580734549cd767429ab709dd43911  -
  2.4.37.1 d22450e8b0f59a5445f868eb44cf681f  -
  2.4.37.10 6561ab83d5f408d2a907e3b3e3387128  -
  2.4.37.11 2d25eeb6339bfce740aacc7d55851141  -
  2.4.37.2 71470ea080b1d889b9aa27295ffa202d  -
  2.4.37.3 5ff755c12bd388920a316e93731b6457  -
  2.4.37.4 474201a6b745be29167584771e175eca  -
  2.4.37.5 6f101339fa78eb675f429e48f7959e83  -
  2.4.37.6 96c2a83d58b4af8dbe97950ae94bd01c  -
  2.4.37.7 ec133f356ba67bcd4108e1a00ede4e74  -
  2.4.37.8 8f7c3d831693919488810177fb399ae8  -
  2.4.37.9 e9f3b73a84dfb6bfd7fe7fd30e8892e9  -

Those md5 should be compared with the ones from the uncompressed
archives :

  for i in linux-[23].[0-9]*.tar.bz2; do
    echo -n "$i ";bzcat $i|md5sum
  done

  linux-2.4.37.11.tar.bz2 2d25eeb6339bfce740aacc7d55851141  -

Result: it's correct. With a bit of scripting, it's easy to match
tags signatures with tarballs'.

The same must be done on tar.gz versions too. While typing this mail,
I had the script running on 2.6 tags and here's what I have at this
point (git archive is amazingly fast!) :

  2.6.11 b390eb0350b4f953a53c16dd5c28810e  -
  2.6.12 2aeacc403998f8868a14c6bfde2355cb  -
  2.6.13 f00810aacdbdcbe313b266172595b81c  -
  2.6.14 ff5ad004e49d7ec7adc8b0dd5161736b  -
  2.6.15 183e68cec3f221e4240b8acb0ac2b27d  -
  2.6.16 3437d1e2944a86ca2b31d9b34664df0b  -
  2.6.17 fbca10e30d7df32e87677f39d470b911  -
  2.6.18 4ff78d8a1b1a5fc93760f3d2e49cb709  -
  2.6.19 dbbf2847a6c76aa730bada4018ea4529  -
  2.6.20 3905ab26c24c974e97eee4628ba1f2eb  -
  2.6.20.1 c550ea5cee783951006450caa3dd3f95  -
  2.6.20.10 3865227516b1ed115dcf52eda4ff1ad8  -
  2.6.20.11 235e4c9dda5c423ac3ccd3aee7587553  -
  2.6.20.12 8d9cc27403c29355549998b7966d6350  -
  2.6.20.13 7331349a0e0fe5dbd230fb10900846f4  -
  2.6.20.14 8e7be87759f3ead0852137e366c34a90  -
  2.6.20.15 7bad3d284c2cbbaed0d2338f81e76859  -
  2.6.20.16 25a1013fabd489d302f71bf3cb1837b3  -
  2.6.20.17 5259b132a710eacc1e7489129f3b9e0f  -
  2.6.20.18 4af3439c081f86b68a30d0bd447179c3  -
  2.6.20.19 8bee08600da3f46bce0d2f15b1e3b68e  -
  2.6.20.2 61056db1f9194d0a153ece9572200b4a  -
  2.6.20.20 eb1b62690aa859f6d1deb70695e253a0  -
  2.6.20.21 f85b1a1337f825832d1b39d1c62f457f  -
  2.6.20.3 32820a679e81cdeb454f54d0994cf968  -
  2.6.20.4 dda6d62ecfcfd5d0f2d7ae9bd1107b6b  -
  2.6.20.5 c39381da208d5c15a2710673df5654fc  -
  2.6.20.6 60065c3db7d5ebe97cef36022933ca0d  -
  2.6.20.7 4352dedea3918d2c7d3a059bb00aa580  -
  2.6.20.8 b26f5458b175e3b935586c433aa82c8d  -
  2.6.20.9 12bf096a9ec27317a7fd0bf5241aa86d  -
  2.6.21 53957189a9f2a382973c1063bd2e8954  -
  2.6.21.1 c081d29d0c6ff1b61fd962b8259ecbc6  -
  2.6.21.2 78d892b513b1b323ad12e3d3c69f6dbb  -
  2.6.21.3 26b27b1aacaac870c94c3ce14155489c  -
  2.6.21.4 562dbfe628d7f4ec5be02f2eee444209  -
  2.6.21.5 4c778ee298cba1ba82d8f8ec00959f3d  -
  2.6.21.6 3fc9cbc5f1eabdb79f0f819785aa79ee  -
  2.6.21.7 d4efe4b192ca2be608b75a881ebca902  -
  2.6.22 1db7e438e6a88f0d7588226a75d109c2  -
  2.6.22.1 93e4955063c604799affa171cb6370d4  -
  2.6.22.10 2dc8fd7f16668e1997a74a1e731febe6  -
  2.6.22.11 57eb4df5f3863be6c6be405eb8a97c1a  -
  2.6.22.12 055c7b258abb9489dbced86537c7dc4e  -
  2.6.22.13 c1f411391548652149ea78afd7ffd026  -
  2.6.22.14 ee15acfef4c0e9b787816546129c34a8  -
  2.6.22.15 159067c422109e1b56e43fdf34e049f7  -
  2.6.22.16 cf84f4aca3f11062968b5ce2351560c3  -
  2.6.22.17 18a6b5c1759d2ed3d2552767d76329a0  -
  2.6.22.18 b64d9b8f3c050692538ec941cc6ffd2c  -
  2.6.22.19 5d5f55c4a794af96dfb7de2114755bba  -
  2.6.22.2 5af3437e6ff97f9920d227681f1c7b5e  -
  2.6.22.3 65e5a5d73e732ef3657554b2eeeb3547  -
  2.6.22.4 d2294a1e23ef416c0b03cfb84acccd3f  -
  2.6.22.5 34bfb927e95b7645ecace1becf492b09  -
  2.6.22.6 a610d656962ebfbd46efd96ce0a96c66  -
  2.6.22.7 d89f77ec176b0eab0be04ecdd06c1a2f  -
  2.6.22.8 3b49a858cd506f320fa24adcec47c8ab  -
  2.6.22.9 db2827199bfa42595a25bdad5e6fe500  -
  2.6.23 534de4be852986f77cf75b2c27b797b3  -
  2.6.24 37991d8ae19d709b63c95fb84c50ac30  -
  2.6.25 0772dbf15ef73fe5cb64c91101896b7a  -
  2.6.25.1 ca288f8d0a47a31a2007da996212dace  -
  2.6.25.10 29fbcbf3fa504b000e6b405c681e91eb  -
  2.6.25.11 225c43654b864c303822385572e8df9d  -
  2.6.25.12 f5d46c6ae6d2a97f8d54610d8a71665b  -
  2.6.25.13 d2affb4524db60f4e0c8c79a01fc565b  -
  2.6.25.14 39380a57e0d2826acc72e16e0d0bbe86  -
  2.6.25.15 32c56b46350368ca97f0afc4dc291e4d  -
  2.6.25.16 9701b00fedc1d674db536adc5e5ddf11  -
  2.6.25.17 47b63e5d2f59ea4f945fc954ef4aac29  -
  2.6.25.18 a26142b7c3b02860bc1bb2eddaf621e3  -
  2.6.25.19 78273a08ffe44e3a85a0574e7d67f367  -
  2.6.25.2 5199cfe55c13162661ec4035272e072d  -
  2.6.25.20 6eea4d0acd22b88c124ce2dfe70a716a  -
  2.6.25.3 5857b5bb21fe8d41460e89b87b9f5362  -
  2.6.25.4 e64c0ae28293e0c578a029af170150d2  -
  2.6.25.5 828cad924870acb9643bf4bb0f72cc92  -
  2.6.25.6 6e0ee8c95c9aa2b619dd9159c1eab57d  -
  2.6.25.7 9ccdda12b747a122a94ac30e735ba9f9  -
  2.6.25.8 b1adac6690deea86340d5e18fd7bee7c  -
  2.6.25.9 b737d23e536e7f9bd93a5888656c6a87  -
  2.6.26 fc8cde1368ab6ed0e3f04008b29bea4d  -
  2.6.27 f4a2389af9ab16b0625578217934e2f0  -
  2.6.27.1 b02d388a1b5179fd40139bdc6d5a2ccd  -
  2.6.27.10 18abcd2d7d157c1cb02bc77f9c2834e7  -
  2.6.27.11 38c7b9727f34961d25471cf3962079fd  -
  2.6.27.12 54f8917ddd5b8c0b89e58aa348a725f0  -
  2.6.27.13 18dfed96ccf2ca4874953d5a2618ab63  -
  2.6.27.14 b8721dbdace184d588d68dc5639feb9c  -
  2.6.27.15 c7e39c082d49e20cf5da354e3e603214  -
  2.6.27.16 81462897e5ddab2c09f79f9c58c6bacf  -
  2.6.27.17 5a03443dcef39fc7b6afa3d7ab9e22b4  -
  2.6.27.18 8e272f65bf0c7dc73c57d85dc6c75b9f  -
  2.6.27.19 61e60b5c2fe91f28da019a078be8d0a5  -
  2.6.27.2 104577a9cb43ee17832e6079a05bb37d  -
  2.6.27.20 8324c79cc242afdfe86f1e5964e49d60  -
  2.6.27.21 13a0e7ca645dcc462a2c0f4e265a6760  -
  2.6.27.22 7f76aff66928dab42db7fd9c963b0813  -
  2.6.27.23 399cf04ceb5f05eddea8a9782cc2ddab  -
  2.6.27.24 2cb77153d209a55367edc8398f4afa88  -
  2.6.27.25 bb963116a132b885f4902ddc1e561920  -
  2.6.27.26 0bf3c35f3807bdd95a3e74d691392afd  -
  2.6.27.27 3e4f73295dc177201ab546bcb360feae  -
  2.6.27.28 e52c78805e8f44af814f9e76613e04b2  -
  2.6.27.29 5a7de732a819d219f51fe5b47f645555  -
  2.6.27.3 88b3887f45666600820778d4d10d4d86  -
  2.6.27.30 a19b497d70fe55519e1fc158ce5afe0d  -
  2.6.27.31 f5bd4a54000bbc19b319cd1c084c0b1a  -
  2.6.27.32 7321d15dcab7a704bf4bb78a0bc0c599  -
  2.6.27.33 55fcebf49f18a06e24468d5b4b70dfd9  -
  2.6.27.34 7d8eb3d81e947465a6c0deb52839b20b  -
  2.6.27.35 1289c724be385e99e89593ea39835ad9  -
  2.6.27.36 ee2a5457dcb337956bc03059fc92c2a1  -
  2.6.27.37 e90869665b6e4860828c0f7097aaa513  -
  2.6.27.38 763dbfd6558ce5dee3ae8ce720b2645c  -
  2.6.27.39 dc579c8445954eb512977b28224dfef9  -
  2.6.27.4 dbb8b8b58962acf4945a5d73810330d6  -
  2.6.27.40 a75c56fb79c601fa6a8ee753672895ef  -
  2.6.27.41 832c145c0ad862d038b41c6a09e19e6f  -
  2.6.27.42 5df04b71553553d1e5833c65008425d5  -
  2.6.27.43 50b70a5f28747b070bdfd0bcc7f9529b  -
  2.6.27.44 07f9c9509becfdf6ddef4f142a2b87fd  -
  2.6.27.45 5df8e25fcaaf9ec0b108c68d31c1f23a  -
  2.6.27.46 feb0c66e8af4e3c73bb7675ad99633cb  -
  2.6.27.47 a10aedc65ec24f5b9f5e7d2534adf94e  -
  2.6.27.48 dab808dedf4eb7e1425cdb0b30a4c8cf  -
  2.6.27.49 d0ec0912960ab79e90d228da7fac1d67  -
  2.6.27.5 99b5eb960d4709d8eab162696d7601dd  -
  2.6.27.50 ce3e327c7291fe271340eaf2904a4347  -
  2.6.27.51 3256ec86d0249f6f0bf967718fd35363  -
  2.6.27.52 ed87ed7d7fce749a3faf845c85880ef9  -
  2.6.27.53 108d6b3f2c723bc4360e3bbbb2474aec  -
  2.6.27.54 cc203656605a40fca27f90e993952788  -
  2.6.27.55 28b6bb904578f3bbc3dafe22b0f3512a  -
  2.6.27.56 d135df3b77fe7c83ecc369139719085a  -
  2.6.27.57 8a6cc185e7c91835b12c85969a3f00f3  -
  2.6.27.58 b9f88fc59a5b7dede53249eb1cf056d5  -
  2.6.27.59 b13ed9fb91f415f16549da6b05cf0a55  -
  2.6.27.6 921927e2cce7f3e59c4f76d54c77ffcb  -
  2.6.27.7 da79852b3b31b665ddac1eaff1712747  -
  2.6.27.8 10b609f0af0a4fcf0ed18e2d076d8310  -
  2.6.27.9 b62bfd7ba8a13833440abb458267c8cd  -
  2.6.28 e97b8459593e20a7bd2d75ecce4cd9a1  -
  2.6.29 8354f1b9f6364047278aaa9a160e6010  -
  2.6.29.1 3378af02af06b10b3725a7f90a1e2832  -
  2.6.29.2 df3f8999068ca47425826f97643a9b01  -
  2.6.29.3 0c32afeb514f2909950c10704ea1c251  -
  2.6.29.4 3510ca1d830c8b9fcef92c258d0a4762  -
  2.6.29.5 cef8e5a3bbf183e7ad3281b1f3bfe657  -
  2.6.29.6 3d9def1cc78eac6271b54194434695e3  -
  2.6.30 a1d93463120021669925776fcf94592e  -
  2.6.30.1 1f57a5f8a65bd38e7b9c2f2c1ae32f66  -
  2.6.30.2 bbc68779259558afca403ca041b49073  -
  2.6.30.3 6a5963823ecfc432f36827d5c17b9cd0  -
  2.6.30.4 9a3533d3a716913fdf7f8b73f1beae45  -
  2.6.30.5 b446af3c919a4cf65008b61f75e88cd6  -
  2.6.30.6 4d87e17f3b3448ce7e69afc9debf0efd  -
  2.6.30.7 e5a18192355fc18831f83ad8338378f9  -
  2.6.30.8 f6c70ebeaaa1e0f23cf4310bba9ac827  -
  2.6.30.9 327a5876f9884ac4e2dd79b642790b4f  -
  2.6.31 f3fa1f5cb17d43bdea3cb0b214ee16c4  -
  2.6.31.1 0697e50b0515da0c94700a56acaf84f1  -
  2.6.31.2 4e5ee234f4d1ce8a2a97e81d1c3e5e3e  -
  2.6.31.3 f686666a2218afd13f2c6bc794919615  -
  2.6.31.4 e2e84fc3cea9293517698f2af02e3698  -
  2.6.31.5 a1518ae179af94eb840024655ed4471a  -
  2.6.31.6 660348915031cc50ede9b6ae2028bf52  -
  2.6.32 a0e27bc0c5a53a1a895c76d88a5acc1a  -
  2.6.32.1 5be63bd57f8672db69198a8ec7a04637  -
  2.6.32.10 32aa41fbc18fbe1cf1e8535e677c13a4  -
  2.6.32.11 212f747ca5999b395bcc03799399b8ad  -
  2.6.32.12 b73836b409909ba691e442a851221bab  -
  2.6.32.13 1f72687582dd1bf5aa7d9a1b01ac11f5  -
  2.6.32.14 8af1c02cefc69f902008b6d16e2a5f19  -
  2.6.32.15 c86b467e8649d5b782e5c85d7bada2c3  -
  2.6.32.16 34f9d86da519c3ac868bb6b9c0edf5fd  -
  2.6.32.17 41fa851916eb3e208eb2d07d9a2edc20  -
  2.6.32.18 e93ea8c463c761b6733ca9550de9d28d  -
  2.6.32.19 baa03d63e6eb52c870ef5f4dee6bff81  -
  2.6.32.2 cbd1bab8027a01ec42c28278879a7209  -
  2.6.32.20 9b4b3ccbdb161284db7c50d8fa7a9cc4  -
  2.6.32.21 4e2d3f2ca147c1d18a0c042bb39e8296  -
  2.6.32.22 c1bbd1b7be8f5bc5b8ec845ba4cfa6d6  -
  2.6.32.23 7706a8fa891540f5eaaf0b504505473d  -
  2.6.32.24 e19d2bef8b40fe3870bb0b8e9bfa2f4b  -
  2.6.32.25 1e8ea8d88db9ea220746c317c891c6d7  -
  2.6.32.26 21db42cb4175753d6b702138b2d16035  -
  2.6.32.27 f3b4b1aefc240a75b84ce8c83c1d8203  -
  2.6.32.28 c63f9b5a3344f866620f6ae10be15881  -
  2.6.32.29 a6546c1fad45fa336885860d31f89b9e  -
  2.6.32.3 8dd90672223a82d8cbfa9bf0ecf6c70b  -
  2.6.32.30 8b3e0d9612b61cdbf4a9a01566010fa4  -
  2.6.32.31 5dcf526758804fa382f231073a442ebe  -
  2.6.32.32 a3fd490344081ddc863c85e066c26de4  -
  2.6.32.33 a22b0dd689764e1aa2abcbc4f3f38899  -
  2.6.32.34 7c596527748f917b0df22321b83c9eb9  -
  2.6.32.35 31b9c268a72f183b37a609ce1688ed33  -
  2.6.32.36 21d809b12592e91d100f40ee9c415e94  -
  2.6.32.37 88572d1d95f9417a93db60a954f3ce9c  -
  2.6.32.38 75e4d93ea9c57c28acd169902c70ffe7  -
  2.6.32.39 6d266224d3ff0d136b336228fe108f3a  -
  2.6.32.4 2cf5b76b3aa71790215b45afcfa8906e  -
  2.6.32.40 27cd2ab5f45c83effbca8f894b9bf9a4  -
  2.6.32.41 3da56d911ae16e1d9d04d27e97140094  -
  2.6.32.42 74189193fa0b44a74bfe31de2934396f  -
  2.6.32.43 702e1151878c159021bfed717483d078  -
  2.6.32.5 cc137ff7c3f9cd033bab9ddadfa09b9b  -
  2.6.32.6 d1561434aa81622f6b17b72c8e00c226  -
  2.6.32.7 c0fcd24b3b3783afefda8f77b0c95a03  -
  2.6.32.8 2e09e2ecd521b5fb43cc577e88e98356  -
  2.6.32.9 9e1ddce5bf49fbf740fe4967990b3f83  -
  2.6.33 6fabba8f967b90f85e6ececa26531ddd  -
  2.6.33.1 c604a96b1006c24da58237b9e55195a9  -
  2.6.33.2 6453571f38b4dfaa602f7585a7616c48  -
  2.6.33.3 a940c369b6d48fd3aea62d86d3a3b324  -


Checking the tarballs takes substantially longer on bz2 files,
and requires that we download them, unless the check is run on
kernel.org disks.

Regards,
Willy

